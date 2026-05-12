# frozen_string_literal: true

module EslintParser
  def parse_eslint_output(output)
    offenses = []
    return offenses if output.blank?

    current_file = nil
    output.each_line do |line|
      line = line.strip
      next if line.blank?

      if line.include?('.js') && line.end_with?(':')
        current_file = extract_relative_path(line.chomp(':'))
      elsif current_file && (match = line.match(/Line (\d+): (.+?) \(([^)]+)\)$/))
        offenses << {
          file: current_file,
          line_column: "#{match[1]}:1",
          rule: match[3],
          message: match[2].gsub(/^['"]|['"]$/, '')
        }
      end
    end
    offenses
  end

  private

  def extract_relative_path(full_path)
    if full_path =~ %r{tmp/repositories/\d+/\d+/(.*)}
      Regexp.last_match(1)
    else
      File.basename(full_path)
    end
  end
end
