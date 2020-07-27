class NoticesController < ApplicationController
  skip_before_filter :authorized, :only => [:public_notes]
  before_filter :check_user, :except => [:public_notes]
  # GET /notices
  # GET /notices.xml
  def index
    @notices = @user.notices

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notices }
    end
  end

  # GET /notices/1
  # GET /notices/1.xml
  def show
    @notice = @user.notices.find(params[:id])
    if @notice
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @notice }
      end
    else
      flash[:notice] = 'No notes found.'
      format.html { render :action => "index" }
      format.xml  { render :xml => @notice.errors, :status => :not_found }
    end
  end

  # GET /notices/new
  # GET /notices/new.xml
  def new
    @notice = @user.notices.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @notice }
    end
  end

  # GET /notices/1/edit
  def edit
    @notice = @user.notices.find(params[:id])
  end

  # POST /notices
  # POST /notices.xml
  def create
    @notice = @user.notices.new(params[:notice])
    @notice.user_id = session[:user_id]
    respond_to do |format|
      if @notice.save
        flash[:notice] = 'Note was successfully created.'
        format.html { redirect_to(@notice) }
        format.xml  { render :xml => @notice, :status => :created, :location => @notice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @notice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notices/1
  # PUT /notices/1.xml
  def update
    @notice = @user.notices.find(params[:id])

    respond_to do |format|
      if @notice.update_attributes(params[:notice])
        flash[:notice] = 'Note was successfully updated.'
        format.html { redirect_to(@notice) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @notice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notices/1
  # DELETE /notices/1.xml
  def destroy
    @notice = @user.notices.find(params[:id])
    @notice.destroy

    respond_to do |format|
      format.html { redirect_to(notices_url) }
      format.xml  { head :ok }
    end
  end

  def public_notes
    @notice = Notice.find_by_public_token(params[:id])
    if @notice
      respond_to do |format|
        format.html # public_notes.html.erb
        format.xml  { render :xml => @notice }
      end
    else
      flash[:alert] = 'No notes found'
      redirect_to login_path, :status => 404
    end
  end

  private
  def check_user
    @user = User.find(session[:user_id])
  end
end
