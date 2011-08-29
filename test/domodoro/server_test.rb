require 'test_helper'

module Domodoro
  describe Server do
    include EM::MiniTest::Spec

    before do
      @channel = Channel.new
      @schedule = Schedule.new
      @schedule.generate!
    end

    it 'repeats every message broadcasted to the channel' do
      EM.start_server('127.0.0.1', 8888, Server, @channel, @schedule)

      Server.any_instance.expects(:send_data).with(":start\n")

      @channel << :start
    end

    describe '.start' do
      it 'opens a server with a new channel' do
        Channel.expects(:new).returns @channel
        Schedule.expects(:new).returns @schedule
        EM.expects(:start_server).with('0.0.0.0', '8888', Server, @channel, @schedule)

        Server.start('0.0.0.0', '8888')
      end

      it 'adds a timer by second that calls broadcast every minute', :timeout => 4 do
        Channel.expects(:new).returns(@channel).at_least(1)
        Server.start('0.0.0.0', '8888')

        module Tick
          attr_accessor :num
          extend self
        end

        Tick.num = 0

        now = stub
        Time.expects(:now).at_least(3).returns now
        now.stubs(:hour).returns 0
        now.stubs(:min).returns 0
        now.stubs(:sec).returns 0

        def @channel.broadcast(*args)
          puts 'tick'
          Tick.num += 1
        end

        EM.add_timer(3.5) do
          assert_equal 3, Tick.num
          done!
        end

        wait!
      end
    end

    describe 'on connection' do
      it 'sends the current and next actions to the client', :timeout => 0.3 do
        Server.stubs(:timestamp).returns "13:15"

        EM.start_server('127.0.0.1', 8888, Server, @channel, @schedule)

        FakeSocketClient = Class.new(EM::Connection) do
          include EM::P::ObjectProtocol
          @object = nil
          def self.object=(obj)
            @object = obj
          end
          def receive_object(object)
            self.class.object = object
          end
        end

        EM.connect('127.0.0.1', 8888, FakeSocketClient)

        EM.add_timer(0.25) do
          object = FakeSocketClient.class_eval "@object"

          assert_equal ["13:00", :lunch], object[:current_action]
          assert_equal ["13:30", :start], object[:next_action]

          done!
        end

        wait!
      end
    end

  end
end
