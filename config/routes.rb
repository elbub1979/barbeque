Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',
                                    omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :events do
    resources :comments, only: %i[create destroy]
    resources :subscriptions, only: %i[create destroy]
    resources :photos, only: %i[create destroy]
    post :show, on: :member
  end

  resources :users, only: %i[show edit update]

  root to: 'events#index'
end
