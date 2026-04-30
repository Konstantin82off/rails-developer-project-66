# frozen_string_literal: true

module ApplicationHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def check_state_badge(state)
    case state
    when "created", "cloning", "checking"
      "warning"
    when "finished"
      "success"
    when "failed"
      "danger"
    else
      "secondary"
    end
  end

  def parse_rubocop_output(output)
    offenses = []
    return offenses if output.blank?

    output.each_line do |line|
      line = line.strip
      next if line.blank?

      # Match full offense line
      if (match = line.match(/^(.+?):(\d+):(\d+): [A-Z]: ([^:]+): (.+)$/))
        offenses << {
          file: match[1],
          line_column: "#{match[2]}:#{match[3]}",
          rule: match[4],
          message: match[5]
        }
      end
    end
    offenses
  end

  def parse_eslint_output(output)
    offenses = []
    return offenses if output.blank?

    current_file = nil
    output.each_line do |line|
      line = line.strip
      next if line.blank?

      # Если строка содержит .js и заканчивается на : (путь к файлу)
      if line.include?(".js") && line.end_with?(":")
        current_file = line.chomp(":")
      elsif current_file && (match = line.match(/Line (\d+): (.+?) \(([^)]+)\)$/))
        offenses << {
          file: current_file,
          line_column: "#{match[1]}:1",
          rule: match[3],
          message: match[2].gsub(/^['"]|['"]$/, "")
        }
      end
    end
    offenses
  end

  def parse_linter_output(check, output)
    if check.repository.language == "javascript"
      parse_eslint_output(output)
    else
      parse_rubocop_output(output)
    end
  end

  def github_file_url(repo_full_name, file_path)
    "https://github.com/#{repo_full_name}/blob/main/#{file_path}"
  end

  def localize_date(date, format = :long)
    return "" unless date
    I18n.l(date, format: format)
  end
end
