# frozen_string_literal: true

module ApplicationHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def check_state_badge(state)
    case state
    when 'created', 'cloning', 'checking'
      'warning'
    when 'finished'
      'success'
    when 'failed'
      'danger'
    else
      'secondary'
    end
  end

  def parse_rubocop_output(output)
    offenses = []
    return offenses if output.blank?

    output.each_line do |line|
      line = line.strip
      next if line.blank?

      # Match full offense line
      next unless (match = line.match(/^(.+?):(\d+):(\d+): [A-Z]: ([^:]+): (.+)$/))

      offenses << {
        file: match[1],
        line_column: "#{match[2]}:#{match[3]}",
        rule: match[4],
        message: match[5]
      }
    end
    offenses
  end

  def github_file_url(repo_full_name, file_path)
    "https://github.com/#{repo_full_name}/blob/main/#{file_path}"
  end

  def localize_date(date, format = :long)
    return '' unless date

    I18n.l(date, format: format)
  end
end
