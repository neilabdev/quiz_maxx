Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, controllers: ActiveAdmin::Devise.config.merge({
                                                        registrations: 'users/registrations',
                                                        sessions: 'users/sessions',
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
