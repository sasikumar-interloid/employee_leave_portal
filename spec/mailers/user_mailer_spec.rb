require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '#welcome_email' do
    let(:user) { build(:user, email: 'employee@example.com') }
    let(:mail) { described_class.welcome_email(user) }

    it 'sends to the user email address' do
      expect(mail.to).to eq([user.email])
    end

    it 'uses the expected subject' do
      expect(mail.subject).to eq('Welcome to Employee Leave Portal')
    end

    it 'renders the welcome content' do
      expect(mail.body.encoded).to include("Hello #{user.email}!")
      expect(mail.body.encoded).to include('Welcome to Employee Leave Portal.')
    end
  end
end
