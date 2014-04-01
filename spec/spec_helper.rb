require 'rspec/its'
require 'coveralls'

Coveralls.wear!

RSpec.configure do |config|
  config.order = :random

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
