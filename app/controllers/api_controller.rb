# frozen_string_literal: true

class ApiController < ApplicationController
  include ActionController::MimeResponds

  before_action :authenticate_user!

  # Velow concerns
  include UserAccess
  include ApplyFilters
  include Renders
  include Sortable
end
