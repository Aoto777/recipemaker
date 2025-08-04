Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root 'tweets#index'

  resources :tweets do
    resources :comments, only: [:create]
  end
end
