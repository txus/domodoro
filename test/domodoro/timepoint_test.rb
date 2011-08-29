require 'test_helper'

module Domodoro
  describe Timepoint do
    before do
      @timepoint = Timepoint.new("08:30")
    end

    it 'initializes with an hour/minute timestamp' do
      assert_equal 8,  @timepoint.hour
      assert_equal 30, @timepoint.min
    end

    it 'initializes with hours and minutes as fixnums' do
      timepoint = Timepoint.new(8, 30)
      assert_equal 8,  timepoint.hour
      assert_equal 30, timepoint.min
    end

    describe '#to_s' do
      it 'returns the original timestamp' do
        assert_equal "08:30", @timepoint.to_s
      end
    end

    describe '+' do
      describe 'when the added minutes belong to the next hour' do
        it 'adds time appropriately returning a new timepoint' do
          new_timepoint = @timepoint + 45

          assert_equal 9, new_timepoint.hour
          assert_equal 15, new_timepoint.min
        end
      end

      describe 'within the same hour' do
        it 'works the same way' do
          new_timepoint = @timepoint + 15

          assert_equal 8, new_timepoint.hour
          assert_equal 45, new_timepoint.min
        end
      end
    end

    describe '#after?' do
      before do
        @timepoint = Timepoint.new(8, 30)
      end
      it 'tells if the timepoint is after another timepoint' do
        Timepoint.new(8, 45).after?(@timepoint).must_equal true
        Timepoint.new(9, 15).after?(@timepoint).must_equal true
        Timepoint.new(8, 25).after?(@timepoint).must_equal false
        Timepoint.new(7, 10).after?(@timepoint).must_equal false
      end
    end

    describe '#before?' do
      before do
        @timepoint = Timepoint.new(17, 30)
      end
      it 'tells if the timepoint is before another timepoint' do
        Timepoint.new(17, 15).before?(@timepoint).must_equal true
        Timepoint.new(13, 00).before?(@timepoint).must_equal true
        Timepoint.new(17, 40).before?(@timepoint).must_equal false
        Timepoint.new(19, 10).before?(@timepoint).must_equal false
      end
    end

    describe '#==' do
      before do
        @timepoint = Timepoint.new(8, 30)
      end
      it 'tells if the timepoint equals another timepoint' do
        Timepoint.new(8, 30).must_equal @timepoint
        Timepoint.new(8, 45).wont_equal @timepoint
        Timepoint.new(8, 15).wont_equal @timepoint
      end

      it 'tells if the timepoint equals another string' do
        "08:30".must_equal @timepoint
        "08:45".wont_equal @timepoint
        "08:15".wont_equal @timepoint
      end
    end

    describe '#left_until' do
      it 'returns the time left until another timestamp' do
        Time.stubs(:now).returns stub(:sec => 55)
        @a = Timepoint.new(8, 30)
        @b = Timepoint.new(9, 45)
        @c = Timepoint.new(11, 10)
        @d = Timepoint.new(8, 32)
        @e = Timepoint.new(15, 01)
        @f = Timepoint.new(8, 31)

        assert_equal "01:14:04", @a.left_until(@b)
        assert_equal "01:24:04", @b.left_until(@c)
        assert_equal "00:01:04", @a.left_until(@d)
        assert_equal "06:30:04", @a.left_until(@e)
        assert_equal "00:00:04", @a.left_until(@f)
      end
    end
  end
end
