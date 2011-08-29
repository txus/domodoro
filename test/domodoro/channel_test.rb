require 'test_helper'

module Domodoro
  describe Channel do
    before do
      @channel = Channel.new
    end

    it 'is an EventMachine channel' do
      assert @channel.is_a?(EM::Channel)
    end

    describe 'broadcast' do
      before do
        @schedule = Schedule.new
        @schedule.instance_variable_set(:@times, {
          '08:30' => :start,
          '09:00' => :stop
        })
      end

      describe 'if theres an action for the timestamp' do
        it 'broadcasts it' do
          @channel.expects(:<<).with(
            :action => ["08:30", :start],
            :next_action => ["09:00", :stop]
          )
          @channel.expects(:<<).with(
            :action => ["09:00", :stop],
            :next_action => nil
          )

          @channel.broadcast("08:30", @schedule)
          @channel.broadcast("09:00", @schedule)
        end
      end

      describe 'otherwise' do
        it 'does not' do
          @channel.expects(:<<).never

          @channel.broadcast("07:30", @schedule)
          @channel.broadcast("08:31", @schedule)
        end
      end
    end
  end
end
