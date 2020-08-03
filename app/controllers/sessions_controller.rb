class SessionsController < ApplicationController
  skip_before_filter :authorized, :only => [:new, :create]
  before_filter :redirection_check, :only =>[:new]

  def new; end

  # Login user
  def create
    @user = User.find_by_email(params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
        session[:user_id] = @user.id
        if @user.last_login_at.nil?
          alert = 'Welcome. Please consider completing your profile'
          redirect_path = edit_user_path(@user) 
        else
          alert = 'Logged in'
          redirect_path = notes_path
        end
        update_last_login(@user, redirect_path, alert)
    else
      flash.now[:alert] = 'Username or password is invalid. Make sure you have confirmed registration before logging in.'
      render :action => 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to public_notes_notes_path, :alert => 'Logged out'
  end

  def login; end

  private 
  def update_last_login(user, path, alert)
    user.update_attributes(:last_login_at => Time.now.utc)
    flash[:alert] = alert
    redirect_to path
  end

  def redirection_check
    redirect_to notes_path if logged_in?
  end
end
