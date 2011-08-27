module Domodoro
  class Server < EM::Connection
    attr_reader :channel, :sid

    class << self
      def start(host, port)
        EM.run do
          channel = Channel.new

          EM.start_server(host, port, self, channel)

          EM.add_periodic_timer(1) do
            if Time.now.sec == 0
              channel.broadcast(Time.now.hour, Time.now.min)
            end
          end
        end
      end
    end

    def initialize(channel)
      @channel = channel
    end

    def post_init
      @sid = channel.subscribe { |m| send_data "#{m.inspect}\n" }
    end

    def unbind
      channel.unsubscribe @sid
    end
  end
end
