require 'simplecov'
SimpleCov.start :rails

SimpleCov.configure do
  load_profile 'test_frameworks'

  add_group('Services', 'app/services')
  add_group('Builders', 'app/builders')
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Commented to generate SimpleCov report
  # parallelize(workers: :number_of_processors)

  fixtures :all
end
