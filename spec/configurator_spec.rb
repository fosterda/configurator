require_relative "../configurator"

describe Configurator do
  context "config file doesn't exist" do
    it "raises Exception" do
      expect{described_class.new("non_existent_file")}.to raise_exception(Exception)
    end
  end

  context "config file exists" do
    subject { described_class.new "spec/test_data/config_data"}

    before do
      allow(ConfigItem).to receive(:new)
    end

    describe "getting config items" do
      let(:config_item_1) { double :config_item }
      let(:config_item_2) { double :config_item }
      config_hash_1 = {"username" => "fred", "email" => "fred.bloggs@example.com"}
      config_hash_2 = {"address" => "10.0.1.2", "hostname" => "node1.example.com",
                       "role" => "web server"}

      before do
        allow(ConfigItem).to receive(:new).with("global", config_hash_1).and_return(config_item_1)
        allow(ConfigItem).to receive(:new).with("node-1", config_hash_2).and_return(config_item_2)
        allow(config_item_1).to receive(:name) { "node-1" }
        allow(config_item_2).to receive(:name) { "global" }
        allow(config_item_1).to receive(:all_values) { ["address = 10.0.1.2", "hostname = node1.example.com", "role = web server"] }
        allow(config_item_1).to receive(:value_of_item).with("hostname") { "node1.example.com" }
        allow(config_item_1).to receive(:value_of_item).with("not_here") { nil }
      end

      it "builds config items from config sections" do
        expected_config_items  = [config_item_1, config_item_2]
        expect(subject.config_items).to eq expected_config_items
      end

      it "gets all the config values for a config item when valid section name used" do
        expected_values = ["address = 10.0.1.2", "hostname = node1.example.com", "role = web server"]
        expect(subject.values_for_section("node-1")).to eq expected_values
      end

      it "gets nil when invalid section name used" do
        expect(subject.values_for_section("not_here")).to eq nil
      end

      it "gets a specific value when given a section and a key" do
        expect(subject.value_for_section_key("node-1", "hostname")).to eq "node1.example.com"
      end
      
      it "gets nil when valid section name used, but invalid key" do
        expect(subject.value_for_section_key("node-1", "not_here")).to eq nil
      end

    end
  end
end
