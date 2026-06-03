require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = users(:one)
    assert user.valid?
  end

  test "invalid without email" do
    user = User.new(user_name: 'testuser', first_name: 'Test', last_name: 'User')
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "invalid without user_name" do
    user = User.new(email: 'test@example.com', password: 'password123')
    assert_not user.valid?
    assert_includes user.errors[:user_name], "can't be blank"
  end

  test "user_name unique" do
    duplicate_user = User.new(user_name: users(:one).user_name, email: 'unique@example.com', password: 'password123')
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:user_name], "has already been taken"
  end
end
