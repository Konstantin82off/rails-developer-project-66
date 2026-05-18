# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthConcern

  allow_browser versions: :modern
end
