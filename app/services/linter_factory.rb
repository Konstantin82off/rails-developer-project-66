# frozen_string_literal: true

class LinterFactory
  def self.for(language)
    case language.to_s
    when 'ruby'
      ApplicationContainer[:linter_ruby]
    when 'javascript'
      ApplicationContainer[:linter_javascript]
    else
      raise "Unsupported language: #{language}"
    end
  end
end
