Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: 'sessions' }

  resources :events
  resources :users, only: %i[show edit update]

  root to: 'events#index'
end
