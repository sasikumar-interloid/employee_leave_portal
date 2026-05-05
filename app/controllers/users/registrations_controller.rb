class Users::RegistrationsController < Devise::RegistrationsController
  layout "dashboard", only: [:edit, :update]
  before_action :authenticate_user!, only: [:edit]

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      resource.errors.full_messages.each do |msg|
        flash.now[:alert] ||= ""
        flash.now[:alert] += "#{msg}\n"
      end
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def edit
    self.resource = current_user
    clean_up_passwords resource
    render "dashboard/manage_account"
  end

  protected

  def build_resource(hash = {})
    super
  end

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
