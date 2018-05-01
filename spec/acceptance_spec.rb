require File.join(File.dirname(__FILE__), '/spec_helper')

module Blinky
  describe "Blinky" do

    describe "that has a supported device connected" do

      before(:each) do
        @supported_device = double("supported device",:idVendor => 0x2000, :idProduct => 0x2222)
        allow(@supported_device).to receive(:open).and_return(@supported_device)
        self.connected_devices = [
          double("unsupported device A",:idVendor => 0x1234, :idProduct => 0x5678),
          @supported_device,
          double("unsupported device B",:idVendor => 0x5678, :idProduct => 0x1234)
        ]
        @blinky = Blinky.new("#{File.dirname(__FILE__)}/fixtures")
      end

      it "will provide a single light" do
        expect(@blinky.light).not_to be_nil
        expect(@blinky.lights.length).to eq(1)
      end

      it "can provide a light that can control the device" do
        expect(@supported_device).to receive(:indicate_success)
        @blinky.light.success!
      end

      it "can provide a light that can show where it is" do
        expect(@supported_device).to receive(:indicate_failure).ordered
        expect(@supported_device).to receive(:indicate_success).ordered
        expect(@supported_device).to receive(:indicate_failure).ordered
        expect(@supported_device).to receive(:indicate_success).ordered
        expect(@supported_device).to receive(:indicate_failure).ordered
        expect(@supported_device).to receive(:indicate_success).ordered
        expect(@supported_device).to receive(:indicate_failure).ordered
        expect(@supported_device).to receive(:indicate_success).ordered
        expect(@supported_device).to receive(:indicate_failure).ordered
        expect(@supported_device).to receive(:indicate_success).ordered
        expect(@supported_device).to receive(:turn_off).ordered

        @blinky.light.where_are_you?
      end

    end

    describe "that supports two devices from the same vendor" do

      it "can provide a light that can control the first device" do
        supported_device_one = double("supported device one", :idVendor => 0x1000, :idProduct => 0x1111)
        allow(supported_device_one).to receive(:open).and_return(supported_device_one)
        self.connected_devices = [supported_device_one]
        @blinky = Blinky.new("#{File.dirname(__FILE__)}/fixtures")
        expect(supported_device_one).to receive(:indicate_success)
        @blinky.light.success!
      end

      it "can provide a light that can control the second device" do
        supported_device_two = double("supported device two", :idVendor => 0x1000, :idProduct => 0x2222)
        allow(supported_device_two).to receive(:open).and_return(supported_device_two)
        self.connected_devices = [supported_device_two]
        @blinky = Blinky.new("#{File.dirname(__FILE__)}/fixtures")
        expect(supported_device_two).to receive(:indicate_success)
        @blinky.light.success!
      end
    end

    describe "that has no supported devices connected" do

      before(:each) do
        @devices = [
          double("unsupported device", :idVendor => 0x1234, :idProduct => 0x5678),
          double("unsupported device", :idVendor => 0x5678, :idProduct => 0x1234)
        ]
        self.connected_devices= @devices
      end

      it "will complain" do
        exception = Exception.new("foo")
        expect(NoSupportedDevicesFound).to receive(:new).with(@devices).and_return(exception)
        expect(lambda{Blinky.new("#{File.dirname(__FILE__)}/fixtures")}).to raise_error("foo")
      end

    end

    describe "that has no supported devices connected - but does have one from the same vendor" do

      before(:each) do
        @devices = [
          double("unsupported device from known vendor", :idVendor => 0x1000, :idProduct => 0x5678),
          double("unsupported device", :idVendor => 0x5678, :idProduct => 0x1234)
        ]
        self.connected_devices= @devices
      end

      it "will complain" do
        exception = Exception.new("foo")
        expect(NoSupportedDevicesFound).to receive(:new).with(@devices).and_return(exception)
        expect(lambda{Blinky.new("#{File.dirname(__FILE__)}/fixtures")}).to raise_error("foo")
      end

    end

    describe "that has two supported devices connected" do

      before(:each) do
        @supported_device_one = double("supported device A",:idVendor => 0x1000, :idProduct => 0x1111)
        allow(@supported_device_one).to receive(:open).and_return(@supported_device_one)
        @supported_device_two = double("supported device B",:idVendor => 0x2000, :idProduct => 0x2222)
        allow(@supported_device_two).to receive(:open).and_return(@supported_device_two)

        self.connected_devices = [
          double("unsupported device", :idVendor => 0x1234, :idProduct => 0x5678),
          @supported_device_one,
          @supported_device_two
        ]
        @blinky = Blinky.new("#{File.dirname(__FILE__)}/fixtures")
      end

      it "will provide two lights" do
        expect(@blinky.light).not_to be_nil
        expect(@blinky.lights.length).to eq(2)
      end

      it "can provide lights that can control thedevices" do
        expect(@supported_device_one).to receive(:indicate_success)
        expect(@supported_device_two).to receive(:indicate_success)
        @blinky.lights[0].success!
        @blinky.lights[1].success!
      end
    end

    describe "that provides a light that is asked to watch a supported CI server" do

      before(:each) do
        device = double("device",:idVendor => 0x1000, :idProduct => 0x1111)
        allow(device).to receive(:open).and_return(device)
        self.connected_devices = [device]
        @light = Blinky.new("#{File.dirname(__FILE__)}/fixtures").light
      end

      it "can receive call backs from the server" do
        expect(@light).to receive(:notify_build_status)
        @light.watch_mock_ci_server
      end

    end

    def connected_devices= devices
      devices.each do |device|
        allow(device).to receive(:usb_open).and_return(device)
      end
      allow(USB).to receive(:devices).and_return(devices)
    end

  end
end
