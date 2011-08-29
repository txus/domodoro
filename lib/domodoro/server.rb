module Domodoro
  class Server < EM::Connection
    attr_reader :channel

    class << self
      def start(host='0.0.0.0', port='9111')
        puts "#{Time.now} - Domodoro serving at #{host}:#{port}"
        EM.run do
          channel = Channel.new

          EM.start_server(host, port, self, channel)

          EM.add_periodic_timer(1) do
            if Time.now.sec == 0
              channel.broadcast(Time.now.hour, Time.now.min)
            else
              EM.next_tick do
                print_time
              end
            end
          end
        end
      end

      def print_time
        hour = Time.now.hour.to_s.rjust(2, '0')
        min  = Time.now.min.to_s.rjust(2, '0')
        secs = Time.now.sec.to_s.rjust(2, '0')
        $stdout.print "\r"
        $stdout.print " " * 20
        $stdout.print "\r"
        $stdout.print "#{hour}:#{min}:#{secs}"
        $stdout.flush
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
