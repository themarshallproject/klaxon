source "https://rubygems.org"
ruby "3.4.8"

gem "rails", "~> 8.1.2"

# Framework
gem "bootsnap", require: false
gem "puma", "~> 7.2"

# Configuration
gem "dotenv"

# Database
gem "pg", "~> 1.6"

# Assets
gem "dartsass-rails", "~> 0.5.1"
gem "propshaft"

# Authentication
gem "jwt"

# Forms
gem "simple_form", "~> 5.4"

# Content processing
gem "diffy"
gem "kramdown"
gem "premailer-rails"

# Integrations
gem "aws-sdk-sqs", "~> 1.111"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rspec-rails"
  gem "factory_bot_rails", "~> 6.5"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rspec_rails", require: false
end

group :test do
  gem "webmock"
  gem "rspec-github", require: false
end

group :development do
  gem "dockerfile-rails", ">= 1.2"
  gem "letter_opener"
  gem "web-console"
end
