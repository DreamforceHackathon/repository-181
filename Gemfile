source 'https://rubygems.org'

# ruby
ruby '2.1.2'

gem 'puma'

# rails
gem 'rails', '4.1.6'
gem 'sinatra', '>= 1.3.0', :require => nil

gem 'dotenv-rails'

gem 'active_model_serializers'

gem 'sidekiq'

# db
gem 'pg'
gem 'redis'

# front end
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'slim-rails'

gem 'premailer-rails', '1.7.0'
gem 'nokogiri'

gem 'seed_dump'

gem 'paperclip'
gem 'aws-sdk', '~> 1.34'

gem 'foreman'

gem 'devise'
gem 'omniauth-salesforce'

gem 'restforce', git: "https://github.com/crisply/restforce"

group :development do
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :production do
  gem 'rails_12factor'
end
