# frozen_string_literal: true

module ApplicationHelper
  include RubocopParser
  include EslintParser

  def check_state_badge(state)
    case state
    when 'created', 'checking'
      'warning'
    when 'finished'
      'success'
    when 'failed'
      'danger'
    else
      'secondary'
    end
  end

  def parse_linter_output(check, output)
    if check.repository.language == 'javascript'
      parse_eslint_output(output)
    else
      parse_rubocop_output(output)
    end
  end

  def github_file_url(repo_full_name, file_path)
    "https://github.com/#{repo_full_name}/blob/main/#{file_path}"
  end

  def localize_date(date, format = :long)
    return '' unless date

    I18n.l(date, format: format)
  end
end
