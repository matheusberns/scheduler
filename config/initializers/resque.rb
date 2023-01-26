# frozen_string_literal: true

Resque.redis = 'localhost:6379'
Resque.logger = Logger.new $stdout
Resque.logger.level = Logger::DEBUG
