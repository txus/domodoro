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

      def current_action
        @current_action
      end

      def current_action=(action)
        @current_action = action
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
                Client.work
              when :stop
                Client.break
              when :lunch
                Client.lunch
              when :go_home
                Client.home
              end
              Client.current_action = object[:current_action]
              Client.next_action    = object[:next_action]
              puts
            end
          end
          EM.add_periodic_timer(1) do
            EM.next_tick do
              if Client.connected && Client.current_action
                print_status
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

      def name_for(action)
        case action.to_s
        when "start" then "Pomodoro"
        when "stop" then "Pomodoro Break"
        when "lunch" then "Lunch time"
        when "go_home" then "Go home"
        end
      end

      def path_to(asset)
        File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'assets', asset))
      end

      def print_status
        current_action = name_for(Client.current_action.last)

        if Client.next_action
          next_action    = name_for(Client.next_action.last)

          # Calculate time left until next action
          now       = Timepoint.new(Time.now.hour, Time.now.min)
          timestamp = Timepoint.new(Client.next_action.first)
          time_left = now.left_until(timestamp)
        end

        $stdout.print "\r"
        $stdout.print " " * 100
        $stdout.print "\r"
        $stdout.print "[ #{[Client.current_action.first, current_action].join(' | ')} ]"
        $stdout.print " - Next: #{next_action} in #{time_left}" if Client.next_action
        $stdout.flush
      end

    end
  end
end
