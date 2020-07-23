class UserController < ApplicationController
  skip_before_filter :authorized, :only => [:new, :create]

  # SignUp form
  def new
    redirect_to notices_path if logged_in?
  end

  # SignUp - Create User
  def create
    @user = User.new(:name => params[:user][:name], :email => params[:user][:email],
                     :password => params[:user][:password])
    if @user.save
      session[:user_id] = @user.id
      redirect_to notices_path
    else
      render :action => 'new'
    end
  end

end
