module Domodoro
  class Timepoint
    attr_reader :hour, :min

    def initialize(*args)
      case args.first
      when String
        @hour, @min = args.first.split(':').map(&:to_i)
      when Fixnum
        @hour, @min = args.first, args.last
      end
    end

    def +(minutes)
      hours_to_advance = ((@min + minutes) / 60).to_i

      h = @hour + hours_to_advance
      m = (@min + minutes) % 60

      Timepoint.new("#{h}:#{m}")
    end

    def after?(timepoint)
      if @hour > timepoint.hour
        true
      elsif @hour == timepoint.hour
        @min >= timepoint.min
      else
        false
      end
    end

    def before?(timepoint)
      if @hour < timepoint.hour
        true
      elsif @hour == timepoint.hour
        @min < timepoint.min
      else
        false
      end
    end

    def ==(timepoint)
      case timepoint
      when String
        Timepoint.new(timepoint) == self
      when Timepoint
        @hour == timepoint.hour && @min == timepoint.min
      end
    end

    def to_s
      [@hour, @min].map(&:to_s).map do |number|
        number.rjust(2, '0')
      end.join(':')
    end

    def left_until(timestamp)
      secs = 60 - Time.now.sec
      hours = timestamp.hour - @hour

      if timestamp.hour == @hour
        remaining_minutes = (timestamp.min - @min).to_s.rjust(2, '0')
        return "00:#{remaining_minutes}::#{secs}"
      end

      if timestamp.min < @min
        hours -= 1
      end

      mins = (timestamp.min - @min) % 60

      h = hours.to_s.rjust(2, '0')
      m = mins.to_s.rjust(2, '0')
      s = secs.to_s.rjust(2, '0')

      "#{h}:#{m}:#{s}"
    end
  end
end
