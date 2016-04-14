Rails.application.routes.draw do

  root 'static#feed'

  scope '/watching' do
    get '/' => 'watching#index', as: :watching
    resources :pages
  end

  scope '/embed' do
    get 'inject' => 'embed#inject'
    get 'iframe' => 'embed#iframe'
  end

  get '/help' => 'static#help', as: :help
  get '/feed' => 'static#feed', as: :feed
  get '/diff' => 'static#index', as: :diff

  resources :users

  scope '/login' do
    get '/' => 'sessions#new', as: :login
    get '/token' => 'sessions#token', as: :token_session
    post '/' => 'sessions#create', as: :create_session
    get 'unknown' => 'static#unknown_user', as: :unknown_user
  end
  post '/logout' => 'sessions#destroy', as: :logout

end
