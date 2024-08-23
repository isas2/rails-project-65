# frozen_string_literal: true

Rails.application.routes.draw do

  scope module: :web do
    namespace :admin do
      root to: 'bulletins#index_moderated'
      resources :categories
      resources :bulletins, only: [:index]
      # resources :bulletins, only: [:index] do
      #   collection do
      #     get :index_moderated
      #   end
      # end
    end

    root to: 'bulletins#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete '/logout', to: 'auth#delete'
    resources :bulletins, only: %i[create edit index new show update]
  end
end
