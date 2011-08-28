require 'notify'

module Domodoro
  class Client
    class << self

      def start(host, port)
        Config.load

        EM.run do
          EM.connect(host, port) do |c|
            c.extend EM::P::LineText2
            def c.receive_line(line)
              case line
                when /start/
                  puts "#{Time.now} - Starting pomodoro!"
                  Client.work
                when /stop/
                  puts "#{Time.now} - Pomdoro break!"
                  Client.break
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
            system("afplay #{path_to('stop.wav')} && afplay #{path_to('stop.mp3')}")
          end
        end
      end

      private

      def path_to(asset)
        File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'assets', asset))
      end

    end
  end
end
