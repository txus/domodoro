require 'yaml'

module Domodoro
  module Config
    attr_accessor :visual, :sound
    extend self

    def load
      if File.exist?(File.expand_path('~/.domodororc'))
        file = YAML.load(File.read(File.expand_path('~/.domodororc')))

        self.visual = file['visual']
        self.sound  = file['sound']
      end
    end
  end
end
