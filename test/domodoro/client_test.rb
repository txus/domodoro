require 'test_helper'

module ExampleServer; end

module Domodoro
  describe Client do
    include EM::MiniTest::Spec

    it 'calls .work when receives :start', :timeout => 0.3 do
      EM.start_server '127.0.0.1', 12345, ExampleServer do |conn|
        conn.send_data ":start\n"
      end

      Client.expects(:work)

      Client.start '127.0.0.1', 12345

      EM.add_timer(0.2) do
        mocha_verify
        done!
      end

      wait!
    end

    it 'calls .break when receives :stop', :timeout => 0.3 do
      EM.start_server '127.0.0.1', 12345, ExampleServer do |conn|
        conn.send_data ":stop\n"
      end

      Client.expects(:break)

      Client.start '127.0.0.1', 12345

      EM.add_timer(0.2) do
        mocha_verify
        done!
      end

      wait!
    end

    describe '.work' do
      describe 'if sound is activated' do
        it 'plays a sound', :timeout => 0.2 do
          Config.stubs(:sound).returns true
          Client.expects(:system)
          Client.work

          EM.add_timer(0.1) do
            mocha_verify
            done!
          end
          wait!
        end
      end

      describe 'otherwise' do
        it 'does not play a sound', :timeout => 0.2 do
          Config.stubs(:sound).returns false
          Client.expects(:system).never
          Client.work

          EM.add_timer(0.1) do
            mocha_verify
            done!
          end
          wait!
        end
      end

      describe 'if visual is activated' do
        it 'displays a visual notification', :timeout => 0.2 do
          Config.stubs(:visual).returns true
          Notify.expects(:notify)
          Client.work

          EM.add_timer(0.1) do
            mocha_verify
            done!
          end
          wait!
        end
      end

      describe 'otherwise' do
        it 'does not display any visual notification', :timeout => 0.2 do
          Config.stubs(:visual).returns false
          Notify.expects(:notify).never
          Client.work

          EM.add_timer(0.1) do
            mocha_verify
            done!
          end
          wait!
        end
      end
    end

    describe '.break' do
      describe 'if sound is activated' do
        it 'plays a sound', :timeout => 0.2 do
          Config.stubs(:sound).returns true
          Client.expects(:system)
          Client.break

          EM.add_timer(0.1) do
            mocha_verify
            done!
          end
          wait!
        end

      end

      describe 'otherwise' do
        it 'does not play a sound', :timeout => 0.2 do
          Config.stubs(:sound).returns false
          Client.expects(:system).never
          Client.break

          EM.add_timer(0.1) do
            mocha_verify
            done!
          end
          wait!
        end
      end

      describe 'if visual is activated' do
        it 'displays a visual notification', :timeout => 0.2 do
          Config.stubs(:visual).returns true
          Notify.expects(:notify)
          Client.break

          EM.add_timer(0.1) do
            mocha_verify
            done!
          end
          wait!
        end
      end

      describe 'otherwise' do
        it 'does not display any visual notification', :timeout => 0.2 do
          Config.stubs(:visual).returns false
          Notify.expects(:notify).never
          Client.break

          EM.add_timer(0.1) do
            mocha_verify
            done!
          end
          wait!
        end
      end
    end
  end
end
