# frozen_string_literal: true

require "open3"
require "fileutils"

class RepositoryCheckService
  attr_reader :check, :repository

  def initialize(check_id)
    @check = Repository::Check.find(check_id)
    @repository = @check.repository
  end

  def perform
    update_state(:cloning)

    clone_repository
    update_state(:checking)

    run_linter
    update_state(:finished)
  rescue StandardError => e
    handle_error(e)
  ensure
    cleanup
  end

  private

  def update_state(state)
    case state
    when :cloning
      @check.start_clone!
    when :checking
      @check.complete_clone!
    when :finished
      @check.complete_check!
    end
    @check.save!
  end

  def clone_repository
    @repo_path = Rails.root.join("tmp", "repositories", @repository.id.to_s, @check.id.to_s)
    FileUtils.mkdir_p(@repo_path)

    clone_url = @repository.clone_url
    command = "git clone --depth 1 #{clone_url} #{@repo_path}"

    _stdout, stderr, status = Open3.capture3(command)

    unless status.success?
      raise "Failed to clone repository: #{stderr}"
    end

    sha_command = "git -C #{@repo_path} rev-parse HEAD"
    sha_stdout, _sha_stderr = Open3.capture3(sha_command)
    @check.update!(commit_id: sha_stdout.strip)
  end

  def run_linter
    linter_class = LinterFactory.for(@repository.language)
    result = linter_class.run(@repo_path.to_s)

    @check.update!(
      passed: result[:passed],
      output: result[:output]
    )
  end

  def handle_error(error)
    @check.update!(
      passed: false,
      output: error.message,
      aasm_state: :failed
    )
    Rails.logger.error "Check #{@check.id} failed: #{error.message}"
  end

  def cleanup
    FileUtils.rm_rf(@repo_path) if @repo_path && Dir.exist?(@repo_path)
  end
end
