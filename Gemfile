# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.1.4.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
gem 'image_processing', '~> 1.2'
gem 'mini_magick'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Rack middleware for blocking & throttling.
gem 'rack-attack'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'shoulda-matchers'

  gem 'rubocop', require: false
  gem 'simplecov', require: false
end

group :development do
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Token based authentication for Rails JSON APIs.
gem 'devise', '~> 4.7.3'
gem 'devise_token_auth'

# Enumerations for Ruby with some magic powers!
gem 'enumerate_it'

# A lightning fast JSON:API serializer for Ruby Objects.
gem 'active_model_serializers'

# Pagination library.
gem 'will_paginate'

# Makes http fun again! Ain't no party like a httparty, because a httparty don't stop.
gem 'httparty'

# Rollbar is a real-time exception reporting service for Ruby and other languages.
# gem 'rollbar'

# This gem does some CPF/CNPJ magic. It allows you to create, validate and format CPF/CNPJ, even through the command-line
gem 'cpf_cnpj'

# Resque-scheduler is an extension to Resque that adds support for queueing items in the future.
gem 'resque-scheduler'

# TimeDifference is the missing Ruby method to calculate difference between two given time.
gem 'time_difference'

# Heavy metal SOAP client
gem 'savon', '~> 2.12.0'

# The PDF::Reader library implements a PDF parser conforming as much as possible to the PDF specification from Adobe.
gem 'pdf-reader', '~> 1.4'

# Community Axlsx is an Office Open XML Spreadsheet generator for the Ruby programming language.
gem 'caxlsx'

# Houston is a simple gem for sending Apple Push Notifications. Pass your credentials, construct your message, and send it.
gem 'houston'

# Net::LDAP for Ruby (also called net-ldap) implements client access for the Lightweight Directory Access Protocol (LDAP)
gem 'net-ldap'

# An easy-to-use wrapper for Net::HTTP, Net::HTTPS and Net::FTP.
gem 'open-uri', '~> 0.2.0'
