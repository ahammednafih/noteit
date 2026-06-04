require "test_helper"

class NoteTest < ActiveSupport::TestCase
  test "valid note" do
    note = notes(:one)
    assert note.valid?
  end

  test "invalid without title or content" do
    note = Note.new(user: users(:one))
    assert_not note.valid?
    assert_includes note.errors[:title], "can't be blank"
    assert_includes note.errors[:content], "can't be blank"
  end

  test "friendly_id slug generation" do
    note = Note.create!(title: "Unique Title Here", content: "Some content", user: users(:one))
    assert_equal "unique-title-here", note.slug
  end

  test "generates public token when public is true" do
    note = Note.create!(title: "Public Note", content: "Content", user: users(:one), public: true)
    assert_not_nil note.public_token
    assert_equal 32, note.public_token.length # SecureRandom.hex(16) produces a 32-char hex string
  end

  test "does not generate public token when public is false" do
    note = Note.create!(title: "Private Note", content: "Content", user: users(:one), public: false)
    assert_nil note.public_token
  end
end
