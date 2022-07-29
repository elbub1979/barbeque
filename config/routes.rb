Rails.application.routes.draw do

  # devise_for :users

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :events do
    resources :comments, only: %i[create destroy]
    resources :subscriptions, only: %i[create destroy]
    resources :photos, only: %i[create destroy]
  end

  resources :users, only: %i[show edit update]

  root to: 'events#index'
end
