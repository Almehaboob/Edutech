Rails.application.routes.draw do
  resources :lessons
  resources :titles
  devise_for :users
  resources :users, only: [:index,  :edit, :show, :update ]
  
  resources :courses do
    resources :lessons
  end
  
  root "home#index"
  get 'home/home'
  get 'home/activity'

end
