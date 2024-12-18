Rails.application.routes.draw do

  devise_for :users
  resources :enrollments
  resources :courses do
    resources :lessons
    resources :enrollments, only: [:new, :create]
  end

  resources :users, only: [:index, :edit, :show, :update]
  
  root "home#index"
  get 'home/home'
  get 'home/activity'

end   
