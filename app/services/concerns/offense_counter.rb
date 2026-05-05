# frozen_string_literal: true

module OffenseCounter
  def count_offenses(output, language)
    return 0 if output.blank? || output == 'Test passed'

    if language.to_s == 'javascript'
      count_eslint_offenses(output)
    else
      count_rubocop_offenses(output)
    end
  end

  private

  def count_eslint_offenses(output)
    parsed = begin
      JSON.parse(output)
    rescue StandardError
      nil
    end
    return 0 unless parsed.is_a?(Array)

    parsed.sum { |file| file['errorCount'].to_i + file['warningCount'].to_i }
  end

  def count_rubocop_offenses(output)
    # Ищем JSON в выводе (после предупреждений RuboCop)
    json_match = output.match(/\{.*"summary".*\}/m)
    return text_offense_count(output) unless json_match

    begin
      parsed = JSON.parse(json_match[0])
      parsed.dig('summary', 'offense_count') || 0
    rescue JSON::ParserError
      text_offense_count(output)
    end
  end

  def text_offense_count(output)
    output.lines.count { |line| line.match?(/^\s*\d+:\d+:\s+/) }
  end
end
