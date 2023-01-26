# class ImportCustomersJob < ApplicationJob
#   queue_as :import_customers_job
#
#   def self.scheduled(_queue, _klass, *_args)
#     ImportCustomersJob.import_customers
#   end
#
#   def perform
#     ImportCustomersJob.import_customers
#   end
#
#   def self.import_customers
#   end
# end
