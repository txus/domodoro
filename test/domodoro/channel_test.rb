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
      describe 'in the morning' do
        it 'broadcasts from 8:00 until 12:59' do
          @channel.expects(:morning).with(5).never
          @channel.expects(:morning).with(10).once
          @channel.expects(:morning).with(15).once
          @channel.expects(:morning).with(20).once
          @channel.expects(:morning).with(25).once
          @channel.expects(:morning).with(30).once
          @channel.expects(:morning).with(35).never

          min = 0
          (7..13).each do |hour|
            min += 5
            @channel.broadcast(hour, min)
          end
        end
      end

      describe 'in the afternoon' do
        it 'broadcasts from 13:20 on' do
          @channel.expects(:afternoon).with(5).never
          @channel.expects(:afternoon).with(10).never
          @channel.expects(:afternoon).with(15).never
          @channel.expects(:afternoon).with(20).once
          @channel.expects(:afternoon).with(25).once
          @channel.expects(:afternoon).with(30).once
          @channel.expects(:afternoon).with(35).once

          min = 0
          (13..19).each do |hour|
            min += 5
            @channel.broadcast(hour, min)
          end
        end
      end

      it 'does not broadcast during lunch time' do
        %w(morning afternoon).each do |timespan|
          @channel.expects(timespan).with(5).never
        end

        (0..19).each do |min|
          @channel.broadcast(13, min)
        end
      end
    end

    describe '#morning' do
      describe 'pomodoro starts' do
        it 'broadcasts a :start message when the time is XX:00' do
          @channel.expects(:<<).with(:start)
          @channel.morning 0
        end

        it 'broadcasts a :start message when the time is XX:30' do
          @channel.expects(:<<).with(:start)
          @channel.morning 30
        end
      end

      describe 'pomodoro stops' do
        it 'broadcasts a :stop message when the time is XX:25' do
          @channel.expects(:<<).with(:stop)
          @channel.morning 25
        end

        it 'broadcasts a :stop message when the time is XX:55' do
          @channel.expects(:<<).with(:stop)
          @channel.morning 55
        end
      end

      it 'does not broadcast anything at other times' do
        @channel.expects(:<<).never

        @channel.morning 5
        @channel.morning 10
        @channel.morning 20
        @channel.morning 40
        @channel.morning 50
      end
    end

    describe '#afternoon' do
      describe 'pomodoro starts' do
        it 'broadcasts a :start message when the time is XX:20' do
          @channel.expects(:<<).with(:start)
          @channel.afternoon 20
        end

        it 'broadcasts a :start message when the time is XX:50' do
          @channel.expects(:<<).with(:start)
          @channel.afternoon 50
        end
      end

      describe 'pomodoro stops' do
        it 'broadcasts a :stop message when the time is XX:45' do
          @channel.expects(:<<).with(:stop)
          @channel.afternoon 45
        end

        it 'broadcasts a :stop message when the time is XX:15' do
          @channel.expects(:<<).with(:stop)
          @channel.afternoon 15
        end
      end

      it 'does not broadcast anything at other times' do
        @channel.expects(:<<).never

        @channel.afternoon 5
        @channel.afternoon 10
        @channel.afternoon 25
        @channel.afternoon 40
        @channel.afternoon 55
      end
    end
  end
end
