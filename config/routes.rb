# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check
  root "tweets#index"

 # config/routes.rb
  resources :tweets do
    resources :comments, only: [:create, :destroy]
  end

  resources :featured_recipes, only: [:show], param: :slug do
    resources :comments, only: [:create, :destroy]
  end
end
