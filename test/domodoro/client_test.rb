require 'test_helper'

module ExampleServer
  include EM::P::ObjectProtocol
end

module Domodoro
  describe Client do
    include EM::MiniTest::Spec

    [
      [:start,   :work],
      [:stop,    :break],
      [:lunch,   :lunch],
      [:go_home, :home],
    ].each do |message, action|
      it "calls .#{action} when receives :#{message}", :timeout => 0.3 do
        EM.start_server '127.0.0.1', 12345, ExampleServer do |conn|
          conn.send_object({:current_action => ["08:30", message] })
        end

        Client.expects(action)

        Client.start '127.0.0.1', 12345

        EM.add_timer(0.2) do
          mocha_verify
          done!
        end

        wait!
      end
    end

    %w(work break lunch home).each do |action|
      describe ".#{action}" do
        describe 'if sound is activated' do
          it 'plays a sound', :timeout => 0.3 do
            Config.stubs(:sound).returns true
            Client.expects(:system)
            Client.send action

            EM.add_timer(0.2) do
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
            Client.send action

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
            Client.send action

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
            Client.send action

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
end
