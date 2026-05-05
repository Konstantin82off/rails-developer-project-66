# frozen_string_literal: true

module RepositoryOperations
  def clone_repository
    return if Rails.env.test?

    @repo_path = Rails.root.join('tmp', 'repositories', @repository.id.to_s, @check.id.to_s)
    FileUtils.mkdir_p(@repo_path)

    clone_url = @repository.clone_url
    command = "git clone --depth 1 #{clone_url} #{@repo_path}"

    _stdout, stderr, status = Open3.capture3(command)

    unless status.success?
      raise "Failed to clone repository: #{stderr}"
    end

    update_commit_sha
  end

  def update_commit_sha
    sha_command = "git -C #{@repo_path} rev-parse HEAD"
    sha_stdout, _sha_stderr = Open3.capture3(sha_command)
    @check.update!(commit_id: sha_stdout.strip)
  end

  def cleanup
    FileUtils.rm_rf(@repo_path) if @repo_path && Dir.exist?(@repo_path)
  end
end
