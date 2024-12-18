Rails.application.routes.draw do
  devise_for :users
  resources :enrollments
  resources :courses do
    resources :lessons
    resources :enrollments, only: [:new, :create]  # This handles new and create actions for enrollments
  end

  resources :users, only: [:index, :edit, :show, :update]

  root "home#index"
  get 'home/home'
  get 'home/activity'
end
