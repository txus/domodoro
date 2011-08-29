module Domodoro
  class Server < EM::Connection
    include EM::P::ObjectProtocol

    attr_reader :channel

    class << self
      def start(host='0.0.0.0', port='9111')
        schedule = Schedule.new
        schedule.generate!

        puts "#{Time.now} - Domodoro serving at #{host}:#{port}"
        EM.run do
          channel = Channel.new

          EM.start_server(host, port, self, channel, schedule)

          EM.add_periodic_timer(1) do
            if Time.now.sec == 0
              channel.broadcast(timestamp, schedule)
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

      def timestamp
        hour = Time.now.hour.to_s.rjust(2, '0')
        min  = Time.now.min.to_s.rjust(2, '0')
        [hour, min].join(':')
      end
    end

    def initialize(channel, schedule)
      @channel = channel
      @schedule = schedule
    end

    def post_init
      @sid = channel.subscribe { |m| send_object(m) }
      send_object({
        :current_action => @schedule.current_action(Server.timestamp),
        :next_action    => @schedule.action_after(Server.timestamp)
      })
    end

    def unbind
      channel.unsubscribe @sid
    end
  end
end
