Rails.application.routes.draw do
  root to: 'reservations#index'
  resources :reservations
  resources :target_dates
  resources :rooms

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
