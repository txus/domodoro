require 'test_helper'

describe Domodoro do
  describe '.start' do

    describe 'as a server' do
      it 'spawns a Domodoro server' do
        host, port = stub, stub
        Domodoro::Server.expects(:start).with(host, port)

        Domodoro.start 'serve', host, port
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
