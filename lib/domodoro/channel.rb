module Domodoro
  class Channel < EM::Channel
    def broadcast(hour, min)
      if ENV['DEBUG']
        puts 'debug mode'
        if min % 2 == 0
          puts "#{Time.now} - Starting pomodoro!"
          self << :start
        else
          puts "#{Time.now} - Pomodoro break!"
          self << :stop
        end
        return
      end

      if (hour >= 8 && hour < 13)
        morning(min)
      elsif (hour >= 13 && min >= 20) &&
        afternoon(min)
      end
    end
    def morning(min)
      case min
      when 0, 30
        puts "#{Time.now} - Starting pomodoro!"
        self << :start
      when 25, 55
        puts "#{Time.now} - Pomodoro break!"
        self << :stop
      end
    end

    def afternoon(min)
      case min
      when 20, 50
        puts "#{Time.now} - Starting pomodoro!"
        self << :start
      when 45, 15
        puts "#{Time.now} - Pomodoro break!"
        self << :stop
      end
    end
  end
end
