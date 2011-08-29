require 'test_helper'
require 'ostruct'
require 'pp'

module Domodoro
  describe Schedule do
    before do
      File.stubs(:exist?).returns false
      @schedule = Schedule.new
      @schedule.generate!
      @times = @schedule.to_hash
    end

    describe "before lunch" do
      it 'generates start times correctly' do
        %w(08:30 09:00 09:30 10:00 10:35 11:05 11:35 12:05 12:35).each do |time|
          assert_equal :start, @times[time]
        end
      end

      it 'generates stop times correctly' do
        %w(08:55 09:25 09:55 10:25 11:00 11:30 12:00 12:30).each do |time|
          assert_equal :stop, @times[time]
        end
        assert_equal :lunch, @times["13:00"]
      end
    end

    describe 'after lunch' do
      it 'generates start times correctly' do
        %w(13:30 14:00 14:30 15:00 15:35 16:05).each do |time|
          assert_equal :start, @times[time]
        end
      end

      it 'generates stop times correctly' do
        %w(13:55 14:25 14:55 15:25 16:00).each do |time|
          assert_equal :stop, @times[time]
        end
        assert_equal :go_home, @times["16:30"]
      end
    end

    describe 'uneven, weird schedules' do
      before do
        config = OpenStruct.new
        config.pomodoro_duration = 25
        config.pomodoro_break = 5
        config.long_break_after = 4
        config.day_start = Timepoint.new('9:13')
        config.lunch_time = Timepoint.new('12:49')
        config.lunch_duration = 120
        config.day_end = Timepoint.new('15:00')

        Config.expects(:get_server_configuration).returns config

        @schedule = Schedule.new
        @schedule.generate!
        @times = @schedule.to_hash
      end

      it 'respect lunch' do
        assert_equal :lunch, @times["12:49"]
        assert_equal :start, @times["14:49"]
      end

      it 'respect home' do
        assert_equal :go_home, @times["15:00"]
      end
    end

    describe '#action_after' do
      it 'returns the next action after a given timestamp' do
        times = {
          "08:30" => :start,
          "09:15" => :stop,
          "10:15" => :start,
        }

        @schedule = Schedule.new
        @schedule.instance_variable_set(:@times, times)

        @schedule.action_after("08:30").must_equal ['09:15', :stop]
        @schedule.action_after("08:45").must_equal ['09:15', :stop]
        @schedule.action_after("09:31").must_equal ['10:15', :start]
      end
    end

    describe '#current_action' do
      it 'returns the current or past action on a given timestamp' do
        times = {
          "08:30" => :start,
          "09:15" => :stop,
          "10:15" => :start,
        }

        @schedule = Schedule.new
        @schedule.instance_variable_set(:@times, times)

        @schedule.current_action("08:30").must_equal ['08:30', :start]
        @schedule.current_action("08:31").must_equal ['08:30', :start]
        @schedule.current_action("09:18").must_equal ['09:15', :stop]
        @schedule.current_action("12:18").must_equal ['10:15', :start]
      end
    end

  end
end
