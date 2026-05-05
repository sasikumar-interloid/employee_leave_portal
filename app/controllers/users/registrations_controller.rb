class Users::RegistrationsController < Devise::RegistrationsController
  layout "dashboard", only: [:edit, :update]
  before_action :authenticate_user!, only: [:edit]

  def edit
    self.resource = current_user
    clean_up_passwords resource
    render "dashboard/manage_account"
  end

  protected

  def account_update_params
    params.require(:user).permit(:email)
  end

  def after_update_path_for(_resource)
    dashboard_manage_account_path
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_sign_up_path_for(_resource)
    dashboard_path
  end
end
