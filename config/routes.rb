Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, path: 'auth'

  resources :notes do
    member do
      get :show_public_note
    end
    collection do
      get :my_public_notes
      get :public_notes
      get :search_public_notes
    end
  end

  # Defines the root path route ("/")
  root "notes#root"
end
