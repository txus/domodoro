require 'rubygems'

gem 'minitest'
require 'mocha'
require 'minitest/spec'
require 'purdytest'
require 'minitest/autorun'

require File.join(File.dirname(__FILE__), 'support', 'em-minitest.rb')

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
