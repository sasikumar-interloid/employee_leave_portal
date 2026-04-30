require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let!(:existing_user) { create(:user) }

    it 'validates email uniqueness' do
      duplicate_user = build(:user, email: existing_user.email)
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include('has already been taken')
    end

    it 'requires password complexity' do
      user = build(:user, email: 'complexity@example.com', password: 'password123', password_confirmation: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('must include at least one uppercase letter, one lowercase letter, one number, and one special character')
    end
  end
end
