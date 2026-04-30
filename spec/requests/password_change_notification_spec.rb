require 'rails_helper'

RSpec.describe 'Password change notification', type: :request do
  let(:user) { create(:user) }

  it 'sends an email when a signed-in user changes their password' do
    post user_session_path, params: { user: { email: user.email, password: 'Password123!' } }
    expect(response).to be_redirect

    expect {
      patch user_registration_path, params: {
        user: {
          email: user.email,
          password: 'NewPassword123!',
          password_confirmation: 'NewPassword123!',
          current_password: 'Password123!'
        }
      }
    }.to change(ActionMailer::Base.deliveries, :size).by(1)

    expect(response).to be_redirect

    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq([user.email])
    expect(email.subject).to eq('Password Changed')
    expect(email.body.encoded).to include('your password has been changed')
  end
end
