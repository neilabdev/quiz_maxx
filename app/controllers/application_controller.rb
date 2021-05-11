class ApplicationController < ActionController::Base
  before_action :authenticate_user!


  def authenticate_admin_user!
    raise SecurityError unless current_user.try(:has_admin_access?)
  end
end
