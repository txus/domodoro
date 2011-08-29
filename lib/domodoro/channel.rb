module Domodoro
  class Channel < EM::Channel
    def broadcast(timestamp, schedule)
      action = schedule.to_hash[timestamp]
      if action
        next_action = schedule.action_after(timestamp)
        self << {
          :current_action => [timestamp, action],
          :next_action => next_action
        }
      end
    end
  end
end
