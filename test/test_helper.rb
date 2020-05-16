require 'simplecov'
SimpleCov.start :rails

SimpleCov.configure do
  load_adapter 'test_frameworks'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Commented to generate SimpleCov report
  # parallelize(workers: :number_of_processors)

  fixtures :all
end
