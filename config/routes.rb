Rails.application.routes.draw do

  root 'watching#feed'

  scope 'api' do
    get 'subscriptions' => 'api#subscriptions', as: :api_subscriptions
    get 'users' => 'api#users', as: :api_users
    get 'pages' => 'api#pages', as: :api_pages
    get 'stats' => 'api#stats', as: :api_stats

    scope 'embed' do
      post 'page' => 'api#embed_find_page', as: :embed_find_page
      post 'page/update-selector' => 'api#embed_update_page_selector', as: :embed_update_page_selector
    end

    get '/page-preview' => 'api#page_preview', as: :api_page_preview
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

  get '/changes/page/:change_id' => 'changes#page', as: :page_change
  post '/changes/resend/:change_id' => 'changes#resend', as: :resend_change_notifications
  patch '/changes/:change_id' => 'changes#update', as: :change

  get '/page_snapshots/:page_snapshot_id' => 'page_snapshots#html', as: :show_page_snapshot_html
  get '/page_snapshots/raw/:page_snapshot_id' => 'page_snapshots#raw_html', as: :raw_page_snapshot_html
  get '/page_snapshots/download_html/:page_snapshot_id' => 'page_snapshots#download', as: :download_page_snapshot_html

  scope '/embed' do
    get 'inject' => 'embed#inject'
    get 'iframe' => 'embed#iframe'
  end

  scope '/integrations' do
    get '/' => 'integrations#index', as: :integrations
    resources :slack, as: 'slack_integrations', controller: 'slack_integrations'
    resources :sqs, as: 'sqs_integrations', controller: 'sqs_integrations'
  end

  get '/help' => 'static#help', as: :help

  resources :users do
    get  '/invite' => 'users#invite', as: :invite
    post '/invite' => 'users#create_invite', as: :create_invite
    resources :pages do 
     delete '/' => 'users#unsubscribe', as: :unsubscribe     
    end
    
  end

  scope '/login' do
    get '/' => 'sessions#new', as: :login
    get '/token' => 'sessions#token', as: :token_session
    post '/' => 'sessions#create', as: :create_session
    get 'unknown' => 'sessions#unknown_user', as: :unknown_user
    get 'expired/:user_id' => 'sessions#expired_token', as: :expired_token
  end
  post '/logout' => 'sessions#destroy', as: :logout

end
