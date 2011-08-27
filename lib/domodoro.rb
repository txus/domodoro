require 'eventmachine'

require "domodoro/version"
require "domodoro/channel"
require "domodoro/server"

module Domodoro
  extend self

  def start(action, host, port)
    case action
    when 'serve', 'server'
      Server.start(host, port)
    when 'join', 'connect'
      Client.start(host, port)
    end
  end

  class Client
    class << self
      def start(host, port)
        EM.run do
          EM.connect(host, port) do |c|
            c.extend EM::P::LineText2
            def c.receive_line(line)
              puts "[#{Time.now}]: " + line
              if line =~ /START/ || line =~ /STOP/
                fork do
                  system('afplay alarm.mp3 && afplay alarm.mp3 && afplay alarm.mp3')
                end
              end
            end
          end
        end
      end
    end
  end
end
