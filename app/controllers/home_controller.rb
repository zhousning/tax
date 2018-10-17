class HomeController < ApplicationController
  layout "application_control"
  before_action :authenticate_user!

  def index
  end
end
