require 'test_helper'

module Domodoro
  describe Config do
    describe 'if ~/.domodororc exists' do
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

    describe 'otherwise' do
      it 'sets both options to true' do
        File.stubs(:exist?).returns false

        Domodoro::Config.load

        assert_equal true, Domodoro::Config.visual
        assert_equal true, Domodoro::Config.sound
      end
    end
  end
end
