class PublicNotesController < ApplicationController
  skip_before_filter :authorized
  def index
    @notices = Notice.public_notes.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @notice = Notice.find_by_public_token(params[:id])
    if @notice
      respond_to do |format|
        format.html # public_notes.html.erb
        format.xml  { render :xml => @notice }
      end
    else
      flash[:alert] = 'No notes found'
      redirect_to public_notes_url, :status => 404
    end
  end

  def search
    if params[:content].present?
      @notices = Notice.public_search(params[:content]).paginate(:page => params[:page], :per_page => 10)
      unless @notices.present?
        flash[:alert] = 'No notes found'
        redirect_to public_notes_path
      end
    else
      redirect_to public_notes_path
    end
  end

end
