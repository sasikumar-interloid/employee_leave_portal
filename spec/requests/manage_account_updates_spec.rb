require 'rails_helper'

RSpec.describe 'Manage account updates', type: :request do
  let(:user) { create(:user) }

  def sign_in_as(user, password: 'Password123!')
    post user_session_path, params: { user: { email: user.email, password: password } }
  end

  it 'updates the signed in user email from the manage account form' do
    sign_in_as(user)

    patch user_registration_path, params: { user: { email: 'updated@example.com' } }

    expect(response).to redirect_to(dashboard_manage_account_path)
    expect(user.reload.email).to eq('updated@example.com')
  end

  it 're-renders the manage account page when the email is invalid' do
    sign_in_as(user)

    patch user_registration_path, params: { user: { email: '' } }

    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include('Manage account')
    expect(response.body).to include("Email can't be blank")
  end
end
