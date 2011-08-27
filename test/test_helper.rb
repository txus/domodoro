require 'rubygems'

gem 'minitest'
require 'mocha'
require 'minitest/spec'
require 'purdytest'
require 'minitest/autorun'

Dir['test/support/*.rb'].each do |file|
 require file
end

require 'domodoro'

class MiniTest::Unit::TestCase
  include Mocha::API
  def setup
    mocha_setup
  end
  def teardown
    mocha_teardown
  end
end
