require 'rails_helper'

RSpec.describe 'Auth frontend validation', type: :request do
  PASSWORD_PATTERN = '(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).+'.freeze

  let(:user) { create(:user) }

  def sign_in_as(user, password: 'Password123!')
    post user_session_path, params: { user: { email: user.email, password: password } }
  end

  describe 'sign up page' do
    it 'includes frontend validation hooks' do
      get new_user_registration_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('data-controller="password-visibility form-validation"')
      expect(response.body).to include('form-validation#validateForm')
      expect(response.body).to include('name="user[email]"')
      expect(response.body).to include('required="required"')
      expect(response.body).to include('name="user[password]"')
      expect(response.body).to include('minlength="6"')
      expect(response.body).to include('name="user[password_confirmation]"')
      expect(response.body).to include('data-form-validation-match-field-id="user_password"')
      expect(response.body).to include('data-action="password-visibility#toggle"')
    end
  end

  describe 'edit account page' do
    it 'includes frontend validation hooks' do
      sign_in_as(user)
      get edit_user_registration_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('data-controller="password-visibility form-validation"')
      expect(response.body).to include('name="user[email]"')
      expect(response.body).to include('required="required"')
      expect(response.body).to include('name="user[current_password]"')
      expect(response.body).to include('name="user[password]"')
      expect(response.body).to include('minlength="6"')
      expect(response.body).to include('data-form-validation-required-if-field-id="user_password"')
      expect(response.body).to include('data-form-validation-match-field-id="user_password"')
      expect(response.body).to include("action=\"#{destroy_user_session_path}\"")
      expect(response.body).not_to include('Delete your account')
    end
  end

  describe 'sign in page' do
    it 'includes frontend validation hooks' do
      get new_user_session_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('form-validation')
      expect(response.body).to include('password-visibility')
      expect(response.body).to include('name="user[email]"')
      expect(response.body).to include('required="required"')
      expect(response.body).to include('name="user[password]"')
      expect(response.body).to include('data-password-visibility-input-id="user_password"')
    end
  end

  describe 'forgot password page' do
    it 'includes frontend validation hooks' do
      get new_user_password_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('data-controller="form-validation"')
      expect(response.body).to include('form-validation#validateForm')
      expect(response.body).to include('name="user[email]"')
      expect(response.body).to include('required="required"')
    end
  end

  describe 'change password page' do
    it 'includes frontend validation hooks' do
      raw_token, hashed_token = Devise.token_generator.generate(User, :reset_password_token)
      user.update!(
        reset_password_token: hashed_token,
        reset_password_sent_at: Time.current
      )

      get edit_user_password_path(reset_password_token: raw_token)

      expect(response).to have_http_status(:success)
      expect(response.body).to include('data-controller="password-visibility form-validation"')
      expect(response.body).to include('name="user[reset_password_token]"')
      expect(response.body).to include('name="user[password]"')
      expect(response.body).to include('minlength="6"')
      expect(response.body).to include('required="required"')
      expect(response.body).to include('name="user[password_confirmation]"')
      expect(response.body).to include('data-form-validation-match-field-id="user_password"')
    end
  end
end
