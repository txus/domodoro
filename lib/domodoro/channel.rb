module Domodoro
  class Channel < EM::Channel
    def broadcast(hour, min)
      if ENV['DEBUG']
        if min % 2 == 0
          self << :start
        else
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
        self << :start
      when 25, 55
        self << :stop
      end
    end

    def afternoon(min)
      case min
      when 20, 50
        self << :start
      when 45, 15
        self << :stop
      end
    end
  end
end
