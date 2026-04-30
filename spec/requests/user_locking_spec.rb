require 'rails_helper'

RSpec.describe 'User locking', type: :request do
  let(:user) { create(:user) }

  describe 'account lockout' do
    it 'locks the account after the maximum number of failed sign in attempts' do
      Devise.maximum_attempts.times do
        post user_session_path, params: { user: { email: user.email, password: 'wrong-password' } }
      end

      user.reload

      expect(user.access_locked?).to be true
      expect(user.failed_attempts).to eq(Devise.maximum_attempts)
    end
  end
end
