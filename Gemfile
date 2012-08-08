source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.6'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'awesome_print'
gem 'formtastic'
gem 'high_voltage'
gem 'newrelic_rpm'
gem 'paperclip', '~> 3.0.4'
gem 'pg'
gem 'sass'
gem 'thin'

# We currently use this forked repo as it allows you to nest links to add associations.
# We can move back to the original gem when the gem fixes a bug where nesting causes
# infinite looping and the gem correctly adds nested dynamically added objects to the params.
gem 'cocoon', git: 'git://github.com/jsteiner/cocoon.git', branch: 'scheddo'
gem 'delayed_job_active_record'
gem 'flutie'
gem 'bourbon', '~> 2.1.1'
gem 'jquery-rails'
gem 'omniauth', '~> 1.0'
gem 'omniauth-oauth2', '~> 1.0.2'
gem 'attr_encrypted'
gem 'airbrake', '~> 3.1.0'
gem 'underscore-rails', '~> 1.3.1'
gem 'mail_view'
gem 'rest-client'
gem "zero-clipboard-rails", "~> 1.0.1"

group :development do
  gem 'bundler', '>= 1.2.0.pre'
  gem 'foreman', '~> 0.46.0'
  gem 'heroku'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'dotenv'
  gem 'evergreen', require: 'evergreen/rails'
  gem 'pry'
  gem 'rspec-rails', '~> 2.9.0'
  gem 'sham_rack'
end

group :test do
  gem 'bourne'
  gem 'capybara-webkit', '~> 0.12.0'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'factory_girl_rails', '~> 3.0'
  gem 'launchy'
  gem 'shoulda-matchers', '~> 1.1.0'
  gem 'simplecov', :require => false
  gem 'sinatra'
  gem 'timecop'
  gem 'turnip', '~> 1.0.0'
end

group :staging, :production do
  gem 'sprockets-redirect'
end
