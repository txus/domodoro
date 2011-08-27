module Domodoro
  class Client
    class << self

      def start(host, port)
        EM.run do

          EM.connect(host, port) do |c|
            c.extend EM::P::LineText2
            def c.receive_line(line)
              case line
                when /start/
                  Client.work
                when /stop/
                  Client.break
                end
              end
            end
          end

        end
      end

      def work
        puts "WORK!!!!!"
        fork do
          system('afplay alarm.mp3 && afplay alarm.mp3')
        end
      end

      def break
        puts "BREAK!!!!!"
        fork do
          system('afplay alarm.mp3 && afplay alarm.mp3')
        end
      end

  end
end
