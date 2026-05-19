# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @repository = repositories(:without_checks)
  end

  test 'POST /api/checks should create check' do
    payload = {
      repository: {
        full_name: @repository.full_name
      },
      after: 'abc123'
    }.to_json

    post api_checks_path, params: payload, headers: { 'Content-Type' => 'application/json' }

    assert_response :success

    perform_enqueued_jobs

    check = @repository.checks.find_by(commit_id: 'abc123')
    assert check
  end

  test 'POST /api/checks should return not_found for unknown repository' do
    payload = {
      repository: {
        full_name: 'unknown/repo'
      },
      after: 'abc123'
    }.to_json

    post api_checks_path, params: payload, headers: { 'Content-Type' => 'application/json' }

    assert_response :not_found
  end
end
