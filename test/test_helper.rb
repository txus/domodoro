require 'rubygems'

gem 'minitest'
require 'mocha'
require 'minitest/spec'
require 'purdytest'
require 'minitest/autorun'

if respond_to?(:require_relative)
  require_relative 'support/em-minitest.rb'
else
  Dir['test/support/em-minitest.rb'].each do |file|
   require file
  end
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
