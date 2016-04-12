Rails.application.routes.draw do

  resources :users

  scope 'watching' do
    resources :pages
  end

  root 'static#index'

  get '/help' => 'static#help', as: :help
  get '/feed' => 'static#index', as: :feed

  scope 'login' do
    get '/' => 'sessions#new', as: :login
    get '/token' => 'sessions#token', as: :token_session
    post '/' => 'sessions#create', as: :create_session
    get 'unknown' => 'static#unknown_user', as: :unknown_user
  end
  post '/logout' => 'sessions#destroy', as: :logout

end
