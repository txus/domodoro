require "domodoro/version"
require 'eventmachine'

module Domodoro

  def self.start(action, host, port)
    case action
    when 'serve', 'server'
      Server.start(host, port)
    when 'join', 'connect'
      Client.start(host, port)
    end
  end

  class Channel < EM::Channel
    def morning(min)
      if [0, 30].include?(min)
        self << 'START'
      end
      if [25, 55].include?(min)
        self << 'STOP'
      end
    end

    def afternoon(min)
      # if [20, 50].include?(min)
      #   self << 'START'
      # end
      # if [45, 15].include?(min)
      #   self << 'STOP'
      # end
      if (min % 2 == 0)
        self << 'START'
      else
        self << 'STOP'
      end
    end
  end

  class Server < EM::Connection
    class << self
      def start(host, port)
        EM.run do
          channel = Channel.new

          EM.start_server(host, port, self, channel)

          EM.add_periodic_timer(1) do
            if Time.now.sec == 0
              hour = Time.now.hour
              min = Time.now.min
              if (hour >= 8 && hour < 13)
                channel.morning(min)
              elsif (hour >= 13 && min >= 20) &&
                channel.afternoon(min)
              end
            end
          end
        end
      end
    end

    def initialize(channel)
      @channel = channel
    end

    def post_init
      @sid = @channel.subscribe { |m| send_data "#{m.inspect}\n" }
    end

    def unbind
      @channel.unsubscribe @sid
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
