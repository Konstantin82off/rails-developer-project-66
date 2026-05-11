# frozen_string_literal: true

class Web::HomeController < Web::ApplicationController
  skip_before_action :authenticate_user!

  def index; end
end
