require "test_helper"

class UserSoftDeleteTest < ActionDispatch::IntegrationTest
  test "deactivating an account soft deletes the user" do
    user = users(:locked_candidate)

    post user_session_path, params: {
      user: {
        email: user.email,
        password: "Password123!"
      }
    }

    assert_response :redirect

    assert_no_difference "User.count" do
      delete user_registration_path
    end

    assert_response :redirect

    user.reload

    assert user.deleted_at.present?
  end
end
