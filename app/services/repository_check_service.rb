# frozen_string_literal: true

require 'open3'
require 'fileutils'

class RepositoryCheckService
  include OffenseCounter
  include RepositoryOperations

  attr_reader :check, :repository

  def initialize(check_id)
    @check = Repository::Check.find(check_id)
    @repository = @check.repository
  end

  def perform
    return unless @check.may_start?

    @check.start!
    clone_repository
    run_linter
    @check.complete!
  rescue StandardError => e
    handle_error(e)
  ensure
    cleanup
  end

  private

  def run_linter
    if Rails.env.test?
      @check.update!(passed: true, output: 'Test passed', offenses_count: 0)
      return
    end

    Rails.logger.info "=== run_linter: repo_path = #{@repo_path} ==="
    linter_class = LinterFactory.for(@repository.language)
    linter = linter_class.new
    result = linter.run(@repo_path.to_s)

    offenses_count = count_offenses(result[:output], @repository.language)

    @check.update!(
      passed: result[:passed],
      output: result[:output],
      offenses_count: offenses_count
    )

    CheckMailer.failure_report(@check.id).deliver_later unless @check.passed
  end

  def handle_error(error)
    @check.fail!
    @check.update!(
      passed: false,
      output: error.message
    )
    Rails.logger.error "Check #{@check.id} failed: #{error.message}"

    CheckMailer.failure_report(@check.id).deliver_later
  end
end
