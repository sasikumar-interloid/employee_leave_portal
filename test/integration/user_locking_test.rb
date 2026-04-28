require "test_helper"

class UserLockingTest < ActionDispatch::IntegrationTest
  test "locks the account after the maximum number of failed sign in attempts" do
    user = users(:locked_candidate)

    Devise.maximum_attempts.times do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "wrong-password"
        }
      }
    end

    user.reload

    assert user.access_locked?
    assert_equal Devise.maximum_attempts, user.failed_attempts
  end
end
