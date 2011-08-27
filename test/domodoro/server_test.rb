require 'test_helper'

module Domodoro
  describe Server do
    include EM::MiniTest::Spec

    before do
      @channel = Channel.new
    end

    it 'initializes with a channel' do
      server = Domodoro::Server.new(nil, @channel)
      assert_equal @channel, server.channel
    end

    it 'repeats every message broadcasted to the channel' do
      server = Server.new(nil, @channel)
      EM.start_server('127.0.0.1', 8888, Server, :app => server)

      server.expects(:send_data).with(":start\n")

      @channel << :start
    end

    describe '.start' do
      it 'opens a server with a new channel' do
        Channel.expects(:new).returns @channel
        EM.expects(:start_server).with('0.0.0.0', '8888', Server, @channel)

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

  end
end
