Rails.application.routes.draw do
  get "dashboard/index"
  get "dashboard", to: "dashboard#index", as: :dashboard
  devise_for :users, skip: [:registrations]

  as :user do
    get "users/sign_up", to: "devise/registrations#new", as: :new_user_registration
    get "users/edit", to: "devise/registrations#edit", as: :edit_user_registration
    patch "users", to: "devise/registrations#update", as: :user_registration
    put "users", to: "devise/registrations#update"
    delete "users", to: "devise/registrations#destroy"
    post "users", to: "devise/registrations#create"
  end

  authenticated :user do
    root to: redirect("/users/edit"), as: :authenticated_root
  end

  unauthenticated do
    root to: redirect("/users/sign_in"), as: :unauthenticated_root
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
