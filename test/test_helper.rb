ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  self.fixture_paths = [ Rails.root.join("test/fixtures") ]
  self.use_transactional_tests = true
end
