require File.join(File.dirname(__FILE__), '..', '/spec_helper')
require 'ci_server_plugins/cctray_server_plugin'
module Blinky

  class StubBlinky
  end

  describe "CCTrayServer" do

    before(:each) do
      @blinky = StubBlinky.new
      @blinky.extend(CCTrayServer)
      allow(@blinky).to receive(:run_every)

      @stub_cctray = double("CCTRay ")
      allow(Chicanery::Cctray).to receive(:new).and_return(@stub_cctray)
    end

    it "watches a Chicanery Cctray server at the provided url" do
      expect(Chicanery::Cctray).to receive(:new).with("blinky build", "SOME_URL", {}).and_return(@stub_cctray)
      @blinky.watch_cctray_server "SOME_URL"
    end

    it "watches a Chicanery Cctray server at the provided url and options" do
      expect(Chicanery::Cctray).to receive(:new).with("blinky build", "SOME_URL", {:foo => :bar}).and_return(@stub_cctray)
      @blinky.watch_cctray_server "SOME_URL", {:foo => :bar}
    end

    it "polls every 15 seconds" do
      expect(@blinky).to receive(:run_every).with(15)
      @blinky.watch_cctray_server "SOME_URL"
    end

    it "warns if something goes wrong" do
      expect(@blinky).to receive(:run_every).and_raise "oh no!"
      expect(@blinky).to receive(:warning!)
      expect{@blinky.watch_cctray_server "SOME_URL"}.to raise_error("oh no!")
    end

    it "registers a chinanery run halder that indicates failure when current status has failures" do
      run_handler = nil
      expect(@blinky).to receive(:when_run) { |&block| run_handler = block }
      @blinky.watch_cctray_server "SOME_URL"

      expect(@blinky).to receive(:failure!)
      run_handler.call double("status", :has_failure? => true)
    end

    it "registers a chinanery run halder that indicates success when current status has no failures" do
      run_handler = nil
      expect(@blinky).to receive(:when_run) { |&block| run_handler = block }
      @blinky.watch_cctray_server "SOME_URL"

      expect(@blinky).to receive(:success!)
      run_handler.call double("status", :has_failure? => false)
    end

  end
end
