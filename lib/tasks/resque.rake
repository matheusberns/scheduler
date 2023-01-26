# frozen_string_literal: true

require 'resque/tasks'
require 'resque/scheduler/tasks'

namespace :resque do
  task :setup do
    require 'resque'
  end

  task setup_schedule: :setup do
    require 'resque-scheduler'
    Resque.schedule = YAML.load_file(Rails.root.join('config', 'resque_schedule.yml'))
  end

  task scheduler: :setup_schedule
end

Resque.after_fork = proc { ActiveRecord::Base.establish_connection }
