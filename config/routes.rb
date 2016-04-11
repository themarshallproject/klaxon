Rails.application.routes.draw do


  root 'static#index'

  get '/help' => 'static#help', as: :help
  get '/feed' => 'static#index', as: :feed

  scope 'login' do
    get '/' => 'sessions#new', as: :login
    get '/token' => 'sessions#token', as: :token_session
    post '/' => 'sessions#create', as: :create_session
  end
  post '/logout' => 'sessions#destroy', as: :logout

  resources :users

end
