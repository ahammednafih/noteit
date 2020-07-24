class UserController < ApplicationController
  skip_before_filter :authorized

  # SignUp form
  def new
    redirect_to notices_path if logged_in?
  end

  # SignUp - Create User
  def create
    @user = User.new(:name => params[:user][:name], :email => params[:user][:email],
                     :password => params[:user][:password],:password_confirmation => params[:user][:password_confirmation])
    if @user.save
      UserMailer.deliver_registration_confirmation(@user)
      flash[:alert] = "Please confirm your email address to continue"
      redirect_to login_url
    else
      render :action => 'new'
    end
  end

  def update; end

  def confirm_email
    user = User.first(:conditions => [ "confirm_token like ?", params[:id]])
    if user
      user.email_activate
      flash[:alert] = "Welcome! Your email has been confirmed.Please sign in to continue."
      redirect_to login_url
    else
      flash[:alert] = "Sorry. User does not exist or is already confirmed. Please try to login"
      redirect_to login_url
    end
  end
end