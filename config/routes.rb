Rails.application.routes.draw do
  devise_for :users
  resources :enrollments do
    get :my_students, on: :collection
  end
  resources :courses do
    get :purchased, :pending_review, :created, on: :collection
    resources :lessons
    resources :enrollments, only: [:new, :create]  # This handles new and create actions for enrollments
  end

  resources :users, only: [:index, :edit, :show, :update]

  root "home#index"
  get 'home/home'
  get 'activity', to: 'home#activity'
  get 'analytics', to: 'home#analytics'
end
