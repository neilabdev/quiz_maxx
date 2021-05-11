Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :quiz do
    member do
      post 'start'
      post 'finish'
      get 'score'
    end
  end
  root to:  'home#index'
end
