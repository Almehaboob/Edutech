Rails.application.routes.draw do
  devise_for :users
  resources :courses
  
  root "home#index"
  get 'home/home'

end
