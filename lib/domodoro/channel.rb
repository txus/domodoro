module Domodoro
  class Channel < EM::Channel
    def broadcast(timestamp, schedule)
      if ENV['DEBUG']
        puts 'DEBUG MODE: Start on even minutes, stop on odd minutes'
        if min % 2 == 0
          puts "#{Time.now} - Starting pomodoro!"
          self << :start
        else
          puts "#{Time.now} - Pomodoro break!"
          self << :stop
        end
        return
      end

      action = schedule.to_hash[timestamp]
      if action
        next_action = schedule.action_after(timestamp)
        self << {
          :action => [timestamp, action],
          :next_action => next_action
        }
      end
    end
  end
end
