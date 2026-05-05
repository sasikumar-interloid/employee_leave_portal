require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }

    it 'redirects unauthenticated users to sign in' do
      get :index

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns success for authenticated users' do
      sign_in user

      get :index

      expect(response).to have_http_status(:success)
    end
  end

end
