Rails.application.routes.draw do
  resources :lessons
  resources :titles
  devise_for :users
  resources :courses
  resources :lessons
  resources :users, only: [:index,  :edit, :show, :update ]

  root "home#index"
  get 'home/home'
  get 'home/activity'

end
