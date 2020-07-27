class SessionsController < ApplicationController
  skip_before_filter :authorized, :only => [:new, :create]

  def new
    redirect_to notices_path if logged_in?
  end

  # Login user
  def create
    @user = User.first(:conditions => [ "email like ?", params[:user][:email]])
    if @user && @user.authenticate(params[:user][:password])
      if @user.email_confirmed
        session[:user_id] = @user.id
        redirect_to notices_path, :alert => 'Logged in'
      else
        flash.now[:alert] = 'Please activate your account by following the 
                             instructions in the account confirmation email you received to proceed'
        render :action => 'new'
      end
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
