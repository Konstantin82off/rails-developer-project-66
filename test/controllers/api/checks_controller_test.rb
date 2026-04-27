# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    @repository = repositories(:without_checks)
    @user = users(:one)
    @repository.update!(user: @user) if @repository.user_id != @user.id
  end

  test 'POST /api/checks should create check and return repository info' do
    payload = {
      repository: {
        id: @repository.github_id,
        full_name: @repository.full_name
      },
      after: '4e399ef91a79d45f75d266a4b5783abe8622b739'
    }.to_json

    assert_difference('Repository::Check.count', 1) do
      post api_checks_path, params: payload, headers: { 'Content-Type': 'application/json' }
    end

    assert_response :success
    json_response = response.parsed_body
    assert_equal @repository.id, json_response['id']
    assert_equal @repository.full_name, json_response['full_name']
  end

  test 'POST /api/checks should return not_found for unknown repository' do
    payload = {
      repository: {
        full_name: 'unknown/repo'
      },
      after: 'abc123'
    }.to_json

    post api_checks_path, params: payload, headers: { 'Content-Type': 'application/json' }

    assert_response :not_found
  end
end
