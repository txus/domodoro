require 'eventmachine'

require "domodoro/version"
require "domodoro/channel"
require "domodoro/server"
require "domodoro/client"

module Domodoro
  extend self

  def start(action, *args)
    case action
    when 'serve', 'server'
      Server.start(*args)
    when 'join', 'connect'
      Client.start(*args)
    end
  end
end
