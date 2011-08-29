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
                puts "[#{object[:current_action].first}] - Starting pomodoro!"
                Client.work
              when :stop
                puts "[#{object[:current_action].first}] - Pomodoro break!"
                Client.break
              when :lunch
                puts "[#{object[:current_action].first}] - Lunch time!"
                Client.lunch
              when :go_home
                puts "[#{object[:current_action].first}] - Time to go home!"
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

      %w(work break lunch home).each do |action|
        define_method(action) do
          EM.defer do
            if Config.visual
              Notify.notify "Domodoro", message_for(action)
            end
            if Config.sound
              system("afplay #{path_to("#{action}.wav")}")
            end
          end
        end
      end

      private

      def message_for(action)
        case action.to_s
        when "work" then "Time to work!"
        when "break" then "Time to take a little break."
        when "lunch" then "Lunch time!"
        when "home" then "Ok folks, time to go home!"
        end
      end

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
                 end

        time_left = timestamp.left_until

        $stdout.print "\r"
        $stdout.print " " * 50
        $stdout.print "\r"
        $stdout.print "[ #{Client.current_action} ] - Next: #{action} in #{time_left}"
        $stdout.flush
      end

    end
  end
end
