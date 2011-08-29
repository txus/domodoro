require 'yaml'
require 'ostruct'

module Domodoro
  module Config
    attr_accessor :visual, :sound
    extend self

    def load_client_configuration
      if File.exist?(File.expand_path('~/.domodororc'))
        file = YAML.load(File.read(File.expand_path('~/.domodororc')))

        self.visual = file['visual']
        self.sound  = file['sound']
      else
        self.visual = true
        self.sound  = true
      end
    end

    def get_server_configuration
      config = OpenStruct.new

      if File.exist?(File.expand_path('~/.domodororc'))
        file = YAML.load(File.read(File.expand_path('~/.domodororc')))['server']

        config.pomodoro_duration = file['pomodoro_duration']
        config.pomodoro_break    = file['pomodoro_break']
        config.long_break_after  = file['long_break_after']

        config.day_start         = Timepoint.new(file['day_start'])
        config.day_end           = Timepoint.new(file['day_end'])

        config.lunch_time        = Timepoint.new(file['lunch_time'])
        config.lunch_duration    = file['lunch_duration']
      end

      config.pomodoro_duration ||= 25
      config.pomodoro_break    ||= 5
      config.long_break_after  ||= 4

      config.day_start         ||= Timepoint.new('08:30')
      config.day_end           ||= Timepoint.new('16:30')

      config.lunch_time        ||= Timepoint.new('13:00')
      config.lunch_duration    ||= 30

      config
    end
  end
end
