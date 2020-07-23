class SessionsController < ApplicationController
  skip_before_filter :authorized, :only => [:new, :create]

  def new
    redirect_to notices_path if logged_in?
  end

  # Login user
  def create
    @user = User.first(:conditions => [ "email like ?", params[:user][:email]])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to notices_path, :notice => 'Logged in'
    else
      flash.now[:alert] = 'Username or password is invalid. Please try again'
      render :action => 'new', :status => :not_found
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, :alert => 'Logged out'
  end

  def login; end

end
