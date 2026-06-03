require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @note = notes(:one)
    @public_note = notes(:two)
  end

  # Unauthenticated access tests
  test "should redirect index to login when unauthenticated" do
    get notes_url
    assert_redirected_to new_user_session_url
  end

  test "should get public notes without login" do
    get public_notes_notes_url
    assert_response :success
  end

  test "should show public note via token without login" do
    get show_public_note_note_url(@public_note.public_token)
    assert_response :success
    assert_match @public_note.title, response.body
  end

  test "should search public notes without login" do
    get search_public_notes_notes_url, params: { content: @public_note.content }
    assert_response :success
  end

  # Authenticated access tests
  test "should get index when authenticated" do
    sign_in @user
    get notes_url
    assert_response :success
  end

  test "should get new when authenticated" do
    sign_in @user
    get new_note_url
    assert_response :success
  end

  test "should create note when authenticated" do
    sign_in @user
    assert_difference('Note.count') do
      post notes_url, params: { note: { title: 'New Note', content: 'Some body content', public: false } }
    end
    new_note = Note.order(:created_at).last
    assert_redirected_to note_url(new_note)
  end

  test "should show note when authenticated" do
    sign_in @user
    get note_url(@note)
    assert_response :success
  end

  test "should get edit when authenticated" do
    sign_in @user
    get edit_note_url(@note)
    assert_response :success
  end

  test "should update note when authenticated" do
    sign_in @user
    patch note_url(@note), params: { note: { title: 'Updated Title' } }
    @note.reload
    assert_redirected_to note_url(@note)
    assert_equal 'Updated Title', @note.title
  end

  test "should destroy note when authenticated" do
    sign_in @user
    assert_difference('Note.count', -1) do
      delete note_url(@note)
    end
    assert_redirected_to notes_url
  end

  test "should get my public notes when authenticated" do
    sign_in @user
    get my_public_notes_notes_url
    assert_response :success
  end
end
