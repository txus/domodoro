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
      hours_to_reduce = (60 / @min - minutes).to_i

      h = @hour - hours_to_reduce
      m = (@min - minutes) % 60
      s = 60 - Time.now.sec

      "#{h}:#{m}:#{s}"
    end
  end
end
