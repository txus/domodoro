module Domodoro
  class Schedule
    def initialize
      @times = {}
      @config = Config.get_server_configuration
    end

    def generate!
      # Key points
      @times[@config.lunch_time.to_s] = :lunch
      @times[@config.day_end.to_s] = :go_home



      generate_pomodoros_between(@config.day_start, @config.lunch_time)
      generate_pomodoros_between(@config.lunch_time + @config.lunch_duration, @config.day_end)
    end

    def to_hash
      @times
    end

    def current_action(timestamp)
      times = @times.dup

      if times[timestamp]
        minus_one = false
      else
        minus_one = true
        times[timestamp] = :now
      end

      sorted = times.sort

      idx = sorted.index do |element|
        element == sorted.assoc(timestamp)
      end

      idx = idx - 1 if minus_one

      sorted[idx]
    end

    def action_after(timestamp)
      times = @times.dup
      times[timestamp] ||= :now
      sorted = times.sort

      idx = sorted.index do |element|
        element == sorted.assoc(timestamp)
      end

      sorted[idx + 1]
    end

    private

    def generate_pomodoros_between(start, finish)
      duration = @config.pomodoro_duration
      pomodoro_break = @config.pomodoro_break

      time = start
      long_break_yet = 1

      while time.before?(finish)
        @times[time.to_s] = :start
        time += duration

        break unless time.before?(finish)

        @times[time.to_s] = :stop

        break_rest = pomodoro_break
        break_rest *= 2 if long_break_yet == @config.long_break_after

        time += break_rest

        long_break_yet += 1
      end
    end
  end
end
