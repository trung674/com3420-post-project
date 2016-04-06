source "https://rubygems.org"
ruby '2.1.7'
gem 'rails', '4.2.5.1'
gem 'responders', '~> 2.1'
gem 'activerecord-session_store'

gem 'sqlite3', group: [:development, :test]
gem 'puma'
gem 'pg'

gem 'airbrake', '~> 4.3.5'

# mapping/location gems
gem 'gmaps4rails'
gem 'geocoder'

gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'

gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'select2-rails'
gem 'epi_js'

gem 'simple_form'
gem 'draper'
gem 'ransack'
gem 'will_paginate'
gem 'bootstrap-will_paginate'

gem 'devise', '>= 3.5.2'
gem 'devise_ldap_authenticatable', '>= 0.8.5'
gem 'devise_cas_authenticatable', '>= 1.5.0'
gem 'cancancan'

gem 'whenever'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'delayed-plugins-airbrake'
gem 'daemons'

# Uploading
gem 'carrierwave'
gem 'recaptcha', require: 'recaptcha/rails'

gem 'rest-client', :require => false

# Editor
gem 'mercury-rails', git: 'http://github.com/jejacks0n/mercury'

gem 'auto_strip_attributes', '~> 2.0', :require => false

# Win32 specific gems
platforms :mswin, :mingw, :x64_mingw do
  # coffee-script-source >= 1.9 is broken on Windows
  gem 'coffee-script-source', '~> 1.8.0'

  # tzinfo-data isn't provided natively on Windows
  gem 'tzinfo-data', '~> 1.2015.1'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'byebug'
end

group :development do
  gem 'web-console', '~> 2.2.1'
  gem 'spring'
  gem 'quiet_assets'

  gem 'capistrano', '~> 3.4'
  gem 'capistrano-rails', require: true
  gem 'capistrano-bundler', require: true
  gem 'capistrano-rvm', require: true
  gem 'capistrano-passenger', require: true
  gem 'epi_deploy', github: 'epigenesys/epi_deploy'

  gem 'thin'
  gem 'eventmachine', '>= 1.0.9.1'
  gem 'letter_opener'
  gem 'annotate'
end

group :test do
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'poltergeist'
  gem 'rspec-instafail', require: false
  platforms :mswin, :mingw, :x64_mingw do
    # patched release to fix issues with project path names on Win32
    gem 'cliver', github: 'yaauie/cliver', ref: '5617ce'
  end

  gem 'database_cleaner'
  gem 'launchy'
  gem 'simplecov'
end
