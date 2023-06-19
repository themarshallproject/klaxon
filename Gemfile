source 'https://rubygems.org'
ruby '3.1.4'

gem "rails", '~> 7.0.5'
gem 'pg', '~> 1.5'
gem "sprockets-rails"
gem "dartsass-rails", "~> 0.5.0"
gem "terser", "~> 1.1"

gem 'dotenv'
gem 'jquery-rails'
gem 'bootsnap', require: false

gem 'puma', '~> 6.3'

gem 'simple_form', '~> 5.2'

gem 'jwt'
gem 'premailer-rails'
gem 'httparty'

gem 'diffy'
gem 'kramdown'

gem 'aws-sdk-sqs', '~> 1.58'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
  gem 'guard-rspec', require: false
  gem 'factory_bot_rails', '~> 6.1'
  gem 'database_cleaner'
  gem 'sinatra'
end

group :test do
  gem 'webmock'
  gem 'rails-controller-testing'
  gem 'rspec-github', require: false
end

group :development do
  gem "dockerfile-rails", ">= 1.2"
  gem 'letter_opener'
  gem 'web-console'
end
