require 'test_helper'

module ExampleServer; end

module Received
  attr_accessor :work, :break
  extend self
end

module Domodoro
  describe Client do
    include EM::MiniTest::Spec

    before do
      Received.break = false
      Received.work = false
    end

    it 'calls .work when receives :start', :timeout => 0.2 do
      EM.start_server '127.0.0.1', 12345, ExampleServer do |conn|
        conn.send_data ":start\n"
      end

      Client.start '127.0.0.1', 12345

      def Client.work
        Received.work = true
      end

      EM.add_timer(0.1) do
        assert Received.work
        done!
      end

      wait!
    end

    it 'calls .break when receives :stop', :timeout => 0.2 do
      EM.run do
      EM.start_server '127.0.0.1', 12345, ExampleServer do |conn|
        conn.send_data ":stop\n"
      end

      Client.start '127.0.0.1', 12345

      def Client.break
        Received.break = true
      end

      EM.add_timer(0.1) do
        assert Received.break
        done!
      end

      wait!
      end
    end

    describe '.work' do
      it 'plays a sound if sound is activated'
      it 'displays a growl if growl is activated'
    end

    describe '.break' do
      it 'plays a sound if sound is activated'
      it 'displays a growl if growl is activated'
    end
  end
end
