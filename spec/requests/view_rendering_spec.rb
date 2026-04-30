require 'rails_helper'

RSpec.describe 'View rendering', type: :request do
  let(:user) { create(:user) }

  def sign_in_as(user, password: 'Password123!')
    post user_session_path, params: { user: { email: user.email, password: password } }
  end

  describe 'dashboard' do
    it 'redirects guests to sign in' do
      get dashboard_index_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'renders welcome message for signed in users' do
      sign_in_as(user)
      get dashboard_index_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Welcome to Dashboard')
      expect(response.body).to include('Employee Leave Portal')
    end
  end

  describe 'sign in page' do
    it 'renders key content' do
      get new_user_session_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('<title>Login</title>')
      expect(response.body).to include('Welcome back')
      expect(response.body).to include("href=\"#{new_user_password_path}\"")
      expect(response.body).to include('Forgot password?')
      expect(response.body).to include("href=\"#{new_user_registration_path}\"")
      expect(response.body).to include('Sign up')
      expect(response.body).not_to include('<footer')
    end
  end

  describe 'sign up page' do
    it 'renders key content' do
      get new_user_registration_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('<title>Sign Up</title>')
      expect(response.body).to include('Create your account')
      expect(response.body).to include('name="user[password_confirmation]"')
      expect(response.body).to include('Confirm your password')
      expect(response.body).to include("href=\"#{new_user_session_path}\"")
      expect(response.body).to include('Login')
      expect(response.body).not_to include('<footer')
    end
  end

  describe 'edit account page' do
    it 'renders account management content' do
      sign_in_as(user)
      get edit_user_registration_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('<title>Edit Account</title>')
      expect(response.body).to include('Manage your account')
      expect(response.body).to include('<h3')
      expect(response.body).to include('Session')
      expect(response.body).to include("action=\"#{destroy_user_session_path}\"")
      expect(response.body).to include('Logout')
      expect(response.body).not_to include('<footer')
    end
  end

  describe 'forgot password page' do
    it 'renders reset instructions content' do
      get new_user_password_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('<title>Forgot Password</title>')
      expect(response.body).to include('Reset your password')
      expect(response.body).to include('name="user[email]"')
      expect(response.body).to include('Enter your email')
      expect(response.body).to include("value=\"Send reset instructions\"")
      expect(response.body).not_to include('<footer')
    end
  end

  describe 'change password page' do
    it 'renders new password form' do
      raw_token, hashed_token = Devise.token_generator.generate(User, :reset_password_token)
      user.update!(
        reset_password_token: hashed_token,
        reset_password_sent_at: Time.current
      )

      get edit_user_password_path(reset_password_token: raw_token)

      expect(response).to have_http_status(:success)
      expect(response.body).to include('<title>Change Password</title>')
      expect(response.body).to include('Create a new password')
      expect(response.body).to include('name="user[reset_password_token]"')
      expect(response.body).to include("value=\"Change my password\"")
      expect(response.body).not_to include('<footer')
    end
  end

  describe 'resend confirmation page' do
    it 'renders request form' do
      get new_user_confirmation_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('<title>Resend Confirmation</title>')
      expect(response.body).to include('Confirm your address')
      expect(response.body).to include('name="user[email]"')
      expect(response.body).to include('Enter your email')
      expect(response.body).to include("value=\"Resend confirmation instructions\"")
      expect(response.body).not_to include('<footer')
    end
  end

  describe 'unlock page' do
    it 'renders recovery content and shared links' do
      get new_user_unlock_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('<title>Unlock Account</title>')
      expect(response.body).to include('Unlock your access')
      expect(response.body).to include('name="user[email]"')
      expect(response.body).to include('you@company.com')
      expect(response.body).to include("value=\"Resend unlock instructions\"")
      expect(response.body).to include("href=\"#{new_user_session_path}\"")
      expect(response.body).to include('Log in')
      expect(response.body).to include("href=\"#{new_user_registration_path}\"")
      expect(response.body).to include('Create an account')
      expect(response.body).to include("href=\"#{new_user_password_path}\"")
      expect(response.body).to include('Forgot your password?')
      expect(response.body).to include("href=\"#{new_user_confirmation_path}\"")
      expect(response.body).to include('Resend confirmation instructions')
    end
  end
end
