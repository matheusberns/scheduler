source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use PostgreSQL as the database for Active Record
gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 4.1'

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
  gem 'spring', '3.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Token based authentication for Rails JSON APIs.
gem 'devise', '~> 4.8.0'
gem 'devise_token_auth'

# Enumerations for Ruby with some magic powers!
gem 'enumerate_it'

# Pagination library.
gem 'will_paginate'

# Makes http fun again! Ain't no party like a httparty, because a httparty don't stop.
gem 'httparty'

# Rollbar is a real-time exception reporting service for Ruby and other languages.
gem 'rollbar'

# The New Relic Ruby agent monitors your applications to help you identify and solve performance issues.
gem 'newrelic_rpm'

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
gem 'axlsx_styler'
gem 'caxlsx', '3.1.1'
gem 'caxlsx_rails'

# Roo implements read access for all common spreadsheet types. It can handle:
gem 'roo-xls'

# Apnotic is a gem for sending Apple Push Notifications using the HTTP-2 specifics.
gem 'apnotic'

# Net::LDAP for Ruby (also called net-ldap) implements client access for the Lightweight Directory Access Protocol (LDAP)
gem 'net-ldap'

# Rubyzip is a ruby library for reading and writing zip files
gem 'rubyzip'

# Prawn::Rails provides a simple way of creating PDF views in Rails 3 using the prawn library.
gem 'prawn-rails'

# Simple yet powerful wrapper around the ffmpeg command for reading metadata and transcoding movies.
gem 'streamio-ffmpeg'

# Creates QR code files in png, bmp, png, jpg, tif and svg file format.
gem 'rqrcode', '~> 2.0'

# Object geocoding (by street or IP address), reverse geocoding (coordinates to street address)
gem 'geocoder', '~> 1.7', '>= 1.7.2'

# Uses wkhtmltopdf to create PDFs using HTML
gem 'pdfkit', '~> 0.8.5'

gem 'hexapdf'

# Provides binaries for WKHTMLTOPDF project in an easily accessible package.
gem 'wkhtmltopdf-binary', '0.12.6.5'

# This gem brings back assigns to your controller tests as well as assert_template to both controller and integration tests.
gem 'rails-controller-testing'