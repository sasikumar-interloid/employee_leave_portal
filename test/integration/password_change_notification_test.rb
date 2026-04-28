require "test_helper"

class PasswordChangeNotificationTest < ActionDispatch::IntegrationTest
  test "sends an email when a signed-in user changes their password" do
    user = users(:locked_candidate)

    post user_session_path, params: {
      user: {
        email: user.email,
        password: "Password123!"
      }
    }

    assert_response :redirect

    assert_difference "ActionMailer::Base.deliveries.size", 1 do
      patch user_registration_path, params: {
        user: {
          email: user.email,
          password: "NewPassword123!",
          password_confirmation: "NewPassword123!",
          current_password: "Password123!"
        }
      }
    end

    assert_response :redirect

    email = ActionMailer::Base.deliveries.last

    assert_equal [ user.email ], email.to
    assert_equal "Password Changed", email.subject
    assert_includes email.body.encoded, "your password has been changed"
  end
end
