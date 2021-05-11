Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, ActiveAdmin::Devise.config.merge({
                                                        registrations: 'users/registrations',
                                                        passwords: 'users/passwords'
                                                      })


  resources :quiz do
    member do
      post 'start'
      post 'finish'
      get 'score'
    end
  end
  root to:  'home#index'
end
