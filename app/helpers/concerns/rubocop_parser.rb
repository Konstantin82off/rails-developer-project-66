# frozen_string_literal: true

module RubocopParser
  def parse_rubocop_output(output)
    return [] if output.blank?

    json_content = extract_json_from_output(output)

    if json_content
      parse_rubocop_json(json_content)
    else
      parse_rubocop_text_output(output)
    end
  end

  private

  def extract_json_from_output(output)
    json_match = output.match(/\{.*"files".*\}/m)
    json_match ? json_match[0] : nil
  end

  def parse_rubocop_json(json_content)
    parsed = JSON.parse(json_content)
    offenses = []

    parsed['files']&.each do |file|
      file['offenses']&.each do |offense|
        offenses << build_offense_hash(file['path'], offense)
      end
    end

    offenses
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse RuboCop JSON: #{e.message}"
    []
  end

  def build_offense_hash(file_path, offense)
    {
      file: extract_relative_path(file_path),
      line_column: "#{offense['location']['line']}:#{offense['location']['column']}",
      rule: offense['cop_name'],
      message: offense['message'],
      severity: offense['severity']
    }
  end

  def extract_relative_path(full_path)
    if full_path =~ %r{tmp/repositories/\d+/\d+/(.*)}
      Regexp.last_match(1)
    else
      full_path
    end
  end

  def parse_rubocop_text_output(output)
    offenses = []
    return offenses if output.blank?

    output.each_line do |line|
      line = line.strip
      next if line.blank?

      next unless (match = line.match(/^(.+?):(\d+):(\d+): [A-Z]: ([^:]+): (.+)$/))

      offenses << {
        file: extract_relative_path(match[1]),
        line_column: "#{match[2]}:#{match[3]}",
        rule: match[4],
        message: match[5]
      }
    end
    offenses
  end
end
