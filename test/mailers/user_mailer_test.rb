require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome_email" do
    user = users(:locked_candidate)

    email = UserMailer.welcome_email(user)

    assert_equal [ user.email ], email.to
    assert_equal "Welcome to Employee Leave Portal", email.subject
    assert_includes email.body.encoded, "Welcome to Employee Leave Portal."
  end
end
