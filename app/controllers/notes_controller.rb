class NotesController < ApplicationController
  
  skip_before_filter :authorized, :only => [:public_notes, :show_public_note, :search_public_notes]
  def index
    @notes = @current_user.notes.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notes }
    end
  end

  def show
    @note = @current_user.notes.find(params[:id])
    if @note
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @note }
      end
    else
      flash[:notice] = 'No notes found.'
      format.html { render :action => "index" }
      format.xml  { render :xml => @note.errors, :status => :not_found }
    end
  end

  def new
    @note = @current_user.notes.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @note }
    end
  end

  def edit
    @note = @current_user.notes.find(params[:id])
  end

  def create
    @note = @current_user.notes.new(params[:note])
    @note.user_id = session[:user_id]
    respond_to do |format|
      if @note.save
        flash[:notice] = 'Note was successfully created.'
        format.html { redirect_to(@note) }
        format.xml  { render :xml => @note, :status => :created, 
                             :location => @note }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @note.errors, 
                             :status => :unprocessable_entity }
      end
    end
  end

  def update
    @note = @current_user.notes.find(params[:id])
    respond_to do |format|
      if @note.update_attributes(params[:note])
        flash[:notice] = 'Note was successfully updated.'
        format.html { redirect_to(@note) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @note.errors, 
                             :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @note = @current_user.notes.find(params[:id])
    @note.destroy
    respond_to do |format|
      format.html { redirect_to(notes_url) }
      format.xml  { head :ok }
    end
  end

  def my_public_notes
    @notes = @current_user.notes.is_public.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html # my_public_notes.html.erb
      format.xml  { render :xml => @notes }
    end
  end

  def public_notes
    @notes = Note.public_notes.paginate(:page => params[:page], :per_page => 1)
  end

  def show_public_note
    @note = Note.find_by_public_token(params[:id])
    if @note
      respond_to do |format|
        format.html # public_notes.html.erb
        format.xml  { render :xml => @note }
      end
    else
      flash[:alert] = 'No notes found'
      redirect_to public_notes_note_url, :status => :not_found
    end
  end

  def search_public_notes
    @notes = Note.public_search(params[:content]).paginate(:page => params[:page], :per_page => 1)
    flash[:alert] = 'No notes found' unless @notes.present?
    render 'public_notes'
  end
end
