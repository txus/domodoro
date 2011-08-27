require 'rubygems'

gem 'minitest'
require 'minitest/spec'
require 'minitest/autorun'

Dir['test/support/*.rb'].each do |file|
 require file
end

require 'domodoro'
