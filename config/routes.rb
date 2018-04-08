Rails.application.routes.draw do
  root to: 'reservations#index'
  resources :reservations
  resources :target_dates
  resources :rooms
end
