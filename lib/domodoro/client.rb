require 'notify'

module Domodoro
  class Client
    class << self

      def start(host, port='9111')
        Config.load
        puts "#{Time.now} - Domodoro listening on #{host}:#{port}"
        puts "Visual notifications: #{Config.visual}"
        puts "Sound notifications: #{Config.sound}\n"

        EM.run do
          EM.connect(host, port) do |c|
            c.extend EM::P::LineText2
            def c.receive_line(line)
              case line
                when /start/
                  puts " - Starting pomodoro!"
                  Client.work
                when /stop/
                  puts " - Pomodoro break!"
                  Client.break
              end
            end
          end
          EM.add_periodic_timer(1) do
            EM.next_tick do
              print_time
            end
          end
        end

      end

      def work
        EM.defer do
          if Config.visual
            Notify.notify "Domodoro", "Time to work!"
          end
          if Config.sound
            system("afplay #{path_to('start.wav')}")
          end
        end
      end

      def break
        EM.defer do
          if Config.visual
            Notify.notify "Domodoro", "Take a 5 min. break."
          end
          if Config.sound
            system("afplay #{path_to('stop.wav')}")
          end
        end
      end

      private

      def path_to(asset)
        File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'assets', asset))
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
  end
end
