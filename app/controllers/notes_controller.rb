class NotesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :root, :public_notes, :show_public_note, :search_public_notes ]

  def root
    if user_signed_in?
      redirect_to notes_path
    else
      redirect_to public_notes_notes_path
    end
  end

  def index
    @pagy, @notes = pagy(current_user.notes.order(created_at: :desc), limit: 10)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notes }
    end
  end

  def show
    @note = current_user.notes.friendly.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @note }
    end
  end

  def new
    @note = current_user.notes.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @note }
    end
  end

  def edit
    @note = current_user.notes.friendly.find(params[:id])
  end

  def create
    @note = current_user.notes.build(note_params)
    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: "Note was successfully created." }
        format.json { render json: @note, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @note = current_user.notes.friendly.find(params[:id])
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: "Note was successfully updated." }
        format.json { render json: @note, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note = current_user.notes.friendly.find(params[:id])
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: "Note was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def my_public_notes
    @pagy, @notes = pagy(current_user.notes.is_public.order(created_at: :desc), limit: 10)
    respond_to do |format|
      format.html # my_public_notes.html.erb
      format.json { render json: @notes }
    end
  end

  def public_notes
    @pagy, @notes = pagy(Note.public_notes, limit: 10)
  end

  def show_public_note
    @note = Note.friendly.find(params[:id])
    if @note.public?
      respond_to do |format|
        format.html # show_public_note.html.erb
        format.json { render json: @note }
      end
    else
      flash[:alert] = "No notes found"
      redirect_to public_notes_notes_url, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "No notes found"
    redirect_to public_notes_notes_url, status: :not_found
  end

  def search_public_notes
    query = params[:content]

    if turbo_frame_request?
      if query.present?
        @notes = Note.autocomplete_search(query, current_user).limit(10)
      else
        @notes = Note.public_notes.limit(10)
      end
      render partial: "search_suggestions", locals: { notes: @notes }
    else
      if query.present?
        @notes_scope = Note.public_search(query)
      else
        @notes_scope = Note.public_notes
      end
      @pagy, @notes = pagy(@notes_scope, limit: 10)
      flash.now[:alert] = "No notes found" unless @notes.present?
      render "public_notes"
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :content, :public)
  end
end
