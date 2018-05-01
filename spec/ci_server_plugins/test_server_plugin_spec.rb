require File.join(File.dirname(__FILE__), '..', '/spec_helper')
require 'ci_server_plugins/test_server_plugin'
module Blinky

  class StubBlinky
  end

  describe "TestCiServer" do

    before(:each) do
      @blinky = StubBlinky.new
      @blinky.extend(TestCiServer)
    end

    it "cycles through all possible statuses" do
      expect(@blinky).to receive(:building!).ordered
      expect(@blinky).to receive(:sleep).ordered
      expect(@blinky).to receive(:failure!).ordered
      expect(@blinky).to receive(:sleep).ordered
      expect(@blinky).to receive(:building!).ordered
      expect(@blinky).to receive(:sleep).ordered
      expect(@blinky).to receive(:warning!).ordered
      expect(@blinky).to receive(:sleep).ordered
      expect(@blinky).to receive(:building!).ordered
      expect(@blinky).to receive(:sleep).ordered
      expect(@blinky).to receive(:success!).ordered
      expect(@blinky).to receive(:sleep).ordered
      expect(@blinky).to receive(:off!).ordered

      @blinky.watch_test_server
    end

  end
end
