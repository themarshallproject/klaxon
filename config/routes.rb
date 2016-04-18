Rails.application.routes.draw do

  root 'watching#feed'

  scope 'api' do
    get 'subscriptions' => 'api#subscriptions', as: :api_subscriptions
    get 'users' => 'api#users', as: :api_users
    get 'pages' => 'api#pages', as: :api_pages
    get 'stats' => 'api#stats', as: :api_stats
  end

  scope '/watching' do
    get '/' => 'watching#index', as: :watching

    resources :pages do
      get '/latest-change' => 'pages#latest_change', on: :member
      get '/snapshots' => 'pages#snapshots', on: :member
      get '/setup-compare' => 'pages#setup_compare', on: :member, as: :setup_compare
      get '/compare/:before_id/:after_id' => 'pages#compare', on: :member
    end
  end

  get '/page-change/:change_id' => 'changes#page', as: :page_change

  scope '/embed' do
    get 'inject' => 'embed#inject'
    get 'iframe' => 'embed#iframe'
  end

  scope '/integrations' do
    get '/' => 'integrations#index', as: :integrations
    resources :slack, as: 'slack_integrations', controller: 'slack_integrations'
  end

  get '/help' => 'static#help', as: :help
  get '/choose-snapshot' => 'static#index', as: :diff

  resources :users do
    get  '/invite' => 'users#invite', as: :invite
    post '/invite' => 'users#create_invite', as: :create_invite
  end

  scope '/login' do
    get '/' => 'sessions#new', as: :login
    get '/token' => 'sessions#token', as: :token_session
    post '/' => 'sessions#create', as: :create_session
    get 'unknown' => 'static#unknown_user', as: :unknown_user
  end
  post '/logout' => 'sessions#destroy', as: :logout

end
