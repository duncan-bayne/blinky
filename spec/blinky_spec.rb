require File.join(File.dirname(__FILE__), '/spec_helper')
Dir["#{File.dirname(__FILE__)}/fixtures/device_recipes/**/*.rb"].each { |f| require(f) }
Dir["#{File.dirname(__FILE__)}/fixtures/ci_server_plugins/**/*.rb"].each { |f| require(f) }

module Blinky
  describe "Blinky" do

    it "will construct a light factory with the available plugins and recipes" do
      expected_plugins = [MockCiServer]
      expected_recipes = {
        0x1000 => { 0x2222 => AenimaEngineering::ModelEulogy,  0x1111 => AenimaEngineering::Model462 },
        0x2000 => { 0x2222 => FragileEngineering::ModelWretched }
      }
      expect(LightFactory).to receive(:detect_lights).with( expected_plugins, expected_recipes).and_return([])
      Blinky.new("#{File.dirname(__FILE__)}/fixtures")
    end

    it "will make lights from the light factory available" do
      expected_plugins = [MockCiServer]
      expected_recipes = {
        0x1000 => { 0x2222 => AenimaEngineering::ModelEulogy,  0x1111 => AenimaEngineering::Model462 },
        0x2000 => { 0x2222 => FragileEngineering::ModelWretched }
      }
      lights = ["light one", "light two"]
      expect(LightFactory).to receive(:detect_lights).and_return(lights)
      blinky = Blinky.new("#{File.dirname(__FILE__)}/fixtures")

      expect(blinky.lights).to eql(lights)
      expect(blinky.light).to eq("light one")
    end
  end
end
