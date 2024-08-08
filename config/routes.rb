Rails.application.routes.draw do

  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete '/logout', to: 'auth#delete'
  end

  root to: 'home#index'
end
