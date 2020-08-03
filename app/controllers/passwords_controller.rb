class PasswordsController < ApplicationController
  skip_before_filter :authorized
  before_filter :check_user, :only => [:edit, :update]

  def new; end

  def edit
    if @user.reset_password_sent_at < 2.hour.ago
      flash[:alert] = 'Password reset has expired'
      redirect_to new_password_path
    end
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      user.set_reset_token
      flash[:alert] = 'E-mail sent with password reset instructions.'
    else
      flash[:alert] = 'No user found with that email. Please try again'
    end
    redirect_to new_session_path
  end

  def update
    if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      flash[:alert] = 'Password has been reset!'
      redirect_to new_session_path
    else
      render :edit
    end
  end

  private
  def check_user
    @user = User.find_by_reset_password_token!(params[:id])
  end
  
end
