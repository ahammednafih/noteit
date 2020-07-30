# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :authorized
  helper_method :logged_in?
  helper_method :current_user
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  def current_user
    User.first(:conditions => ["id like ?", session[:user_id]])
  end

  def logged_in?
    current_user.present?
  end

  def authorized
    redirect_to '/login' unless logged_in?
  end
end
