class UsersController < ApplicationController
  skip_before_filter :authorized

  # SignUp form
  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  # SignUp - Create User
  def create
    @user = User.new(
                     :user_name => params[:user][:user_name], 
                     :email => params[:user][:email], 
                     :password => params[:user][:password], 
                     :password_confirmation => params[:user][:password_confirmation]
                    )
    if @user.save
      Mailers::UserMailer.delay.deliver_registration_confirmation(@user)
      flash[:alert] = "Please confirm your email address to continue"
      redirect_to login_url
    else
      render :action => 'new'
    end
  end

  def update
     @user = User.find(params[:id])
     @user.update_attributes(params[:user])
     flash[:notice] = 'Note was successfully updated.'
     redirect_to edit_user_url
  end

  def confirm_email
    user = User.first(:conditions => [ "confirm_token like ?", params[:id]])
    if user
      Services::UserServices.email_activate(user)
      flash[:alert] = 'Welcome! Your email has been confirmed.Please sign in to continue.'
      redirect_to login_url
    else
      flash[:alert] = 'Sorry. User does not exist or is already confirmed. 
                       Please try to login'
      redirect_to login_url
    end
  end
end
