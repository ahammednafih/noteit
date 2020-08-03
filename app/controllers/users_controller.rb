class UsersController < ApplicationController
  skip_before_filter :authorized, :except => [:edit, :update]

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
      flash[:alert] = "Please confirm your email address to continue"
      redirect_to login_url
    else
      render :action => 'new'
    end
  end

  def update
     @user = User.find(params[:id])
     if @user.update_attributes(params[:user])
      flash[:notice] = 'User profile successfully updated.'
      redirect_to edit_user_url
     else
      render :action => 'edit'
     end
  end

  def confirm_email
    user = User.first(:conditions => [ "confirm_token = ?", params[:id]])
    if user && user.set_email_confirmed
      flash[:alert] = 'Welcome! Your email has been confirmed.Please sign in to continue.'
    else
      flash[:alert] = 'Sorry. User does not exist or is already confirmed. 
                       Please try to login'
    end
    redirect_to login_url
  end
end
