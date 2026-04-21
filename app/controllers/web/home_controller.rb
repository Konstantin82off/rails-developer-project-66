# frozen_string_literal: true

module Web
  class HomeController < ApplicationController
    def index
      set_default_format
    end
  end
end
