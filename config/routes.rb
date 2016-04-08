Rails.application.routes.draw do


  root 'static#index'

  scope 'login' do
    get '/' => 'sessions#new', as: :login
    get '/token' => 'sessions#token', as: :token_session
    post '/' => 'sessions#create', as: :create_session
  end
  post '/logout' => 'sessions#destroy', as: :logout

  resources :users

end
