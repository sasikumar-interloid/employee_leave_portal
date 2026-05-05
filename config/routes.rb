Rails.application.routes.draw do
  # -- Authentication ---------------------------------------------------------
  devise_for :users, skip: [:registrations]

  as :user do
    get  "users/sign_up",  to: "users/registrations#new",    as: :new_user_registration
    get  "users/edit",     to: "users/registrations#edit",   as: :edit_user_registration
    post "users",          to: "users/registrations#create", as: :user_registration
    patch "users",         to: "users/registrations#update"
    put "users",          to: "users/registrations#update"
    delete "users",        to: "users/registrations#destroy"
  end

  # -- Root routes ------------------------------------------------------------
  authenticated :user do
    root to: redirect("/dashboard"), as: :authenticated_root
  end

  unauthenticated do
    root to: redirect("/users/sign_in"), as: :unauthenticated_root
  end

  # -- Dashboard --------------------------------------------------------------
  get "dashboard", to: "dashboard#index"

  devise_scope :user do
    get "dashboard/settings/manage_account", to: "users/registrations#edit", as: :dashboard_manage_account
  end

  # -- Health check -----------------------------------------------------------
  get "up" => "rails/health#show", as: :rails_health_check
end
