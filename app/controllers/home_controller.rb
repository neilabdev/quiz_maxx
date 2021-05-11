class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    render :index
  end


end
