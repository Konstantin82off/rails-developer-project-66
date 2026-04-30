# frozen_string_literal: true

module EslintParser
  def parse_eslint_output(output)
    offenses = []
    return offenses if output.blank?

    current_file = nil
    output.each_line do |line|
      line = line.strip
      next if line.blank?

      # Если строка заканчивается на .js (путь к файлу)
      if line.end_with?('.js') && !line.include?(':')
        current_file = line
      elsif current_file && (match = line.match(/Line (\d+): (.+?) \(([^)]+)\)$/))
        offenses << {
          file: current_file,
          line_column: "#{match[1]}:1",
          rule: match[3],
          message: match[2].gsub(/^['"]|['"]$/, '')  # убираем кавычки
        }
      end
    end
    offenses
  end
end
