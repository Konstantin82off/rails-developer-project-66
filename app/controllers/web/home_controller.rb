# frozen_string_literal: true

module Web
  class HomeController < ApplicationController
    def index
      set_default_format
      render :index
    end
  end
end
