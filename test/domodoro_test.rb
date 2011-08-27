require 'test_helper'

describe Domodoro do
  describe '.start' do

    describe 'as a server' do
      it 'spawns a Domodoro server' do
        port = stub
        Domodoro::Server.expects(:start).with(port)

        Domodoro.start 'serve', port
      end
    end

    describe 'as a client' do
      it 'starts a Domodoro client' do
        host, port = stub, stub
        Domodoro::Client.expects(:start).with(host, port)

        Domodoro.start 'join', host, port
      end
    end

  end
end
