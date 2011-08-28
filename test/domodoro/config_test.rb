require 'test_helper'

module Domodoro
  describe Config do
    it 'loads the config from a ~/.domodororc file' do
      File.stubs(:exist?).returns true
      File.stubs(:read).returns """
visual: true
sound: false
  """
      Domodoro::Config.load

      assert_equal true, Domodoro::Config.visual
      assert_equal false, Domodoro::Config.sound
    end
  end
end
