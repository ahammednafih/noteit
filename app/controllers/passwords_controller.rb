class PasswordsController < ApplicationController
  skip_before_filter :authorized
  def new
  end

  def edit
    @user = User.find_by_reset_password_token!(params[:id])
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_password_reset 
      flash[:notice] = 'E-mail sent with password reset instructions.'
      redirect_to new_session_path
    else
      flash[:notice] = 'E-mail sent with password reset instructions.'
      redirect_to new_password_path
    end
  end

  def update
    @user = User.find_by_reset_password_token!(params[:id])
    if @user.reset_password_sent_at < 2.hour.ago
      flash[:notice] = 'Password reset has expired'
      redirect_to new_password_path
    elsif @user.update_attributes(:password => params[:user][:password])
      flash[:notice] = 'Password has been reset!'
      redirect_to new_session_path
    else
      render :edit
    end
  end
  
end
