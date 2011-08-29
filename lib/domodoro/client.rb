require 'notify'

module Domodoro
  class Client
    class << self

      def connected
        @connected
      end

      def connected=(value)
        @connected = true
      end

      def next_action
        @next_action
      end

      def next_action=(action)
        @next_action = action
      end

      def start(host, port='9111')
        Config.load_client_configuration
        puts "#{Time.now} - Domodoro listening on #{host}:#{port}"
        puts "Visual notifications: #{Config.visual}"
        puts "Sound notifications: #{Config.sound}\n"

        EM.run do
          EM.connect(host, port) do |c|
            c.extend EM::P::ObjectProtocol
            def c.connection_completed
              puts " - Connected to server!"
              Client.connected = true
            end
            def c.receive_object(object)
              case object[:current_action].last
              when :start
                puts "[#{object[:current_action]}] - Starting pomodoro!"
                Client.work
              when :stop
                puts "[#{object[:current_action]}] - Pomodoro break!"
                Client.break
              when :lunch
                puts "[#{object[:current_action]}] - Lunch time!"
                Client.lunch
              when :go_home
                puts "[#{object[:current_action]}] - Time to go home!"
                Client.home
              end
              Client.next_action = object[:next_action]
            end
          end
          EM.add_periodic_timer(1) do
            EM.next_tick do
              if Client.connected
                print_next_action
              else
                puts 'Cannot connect to server. Is it running?'
              end
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

      def lunch
        EM.defer do
          if Config.visual
            Notify.notify "Domodoro", "Lunch time!"
          end
          if Config.sound
            system("afplay #{path_to('lunch.wav')}")
          end
        end
      end

      def home
        EM.defer do
          if Config.visual
            Notify.notify "Domodoro", "Time to go home!"
          end
          if Config.sound
            system("afplay #{path_to('home.wav')}")
          end
        end
      end

      private

      def path_to(asset)
        File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'assets', asset))
      end

      def print_next_action
        timestamp = Timepoint.new(Client.next_action.first)
        action = case Client.next_action.last
                 when :start   then "Pomodoro"
                 when :stop    then "Pomodoro Break"
                 when :lunch   then "Lunch time"
                 when :go_home then "Go home"

        time_left = timestamp.left_until

        $stdout.print "\r"
        $stdout.print " " * 50
        $stdout.print "\r"
        $stdout.print "Next: #{action} in #{time_left}"
        $stdout.flush
      end

    end
  end
end
