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

    it "returns lines from config file" do
      expected_lines = ["[global]\n", "  username= fred\n", "  email = fred.bloggs@example.com\n",
                        "# Node definitions\n", "[node-1]\n", "  address = 10.0.1.2\n",
                        "  hostname = node1.example.com\n", "  role =  web server # backup\n"]

      expect(subject.file_lines).to eq expected_lines
    end

    it "builds config sections from file" do
      expected_sections = [
                           ["global", "  username= fred\n", "  email = fred.bloggs@example.com\n"],
                           ["node-1", "  address = 10.0.1.2\n", "  hostname = node1.example.com\n",
                            "  role =  web server # backup\n"]
                          ]

      expect(subject.config_sections).to eq expected_sections
    end

    describe "building config items" do
      let(:config_item_1) { double :config_item }
      let(:config_item_2) { double :config_item }
      config_hash_1 = {"username" => "fred", "email" => "fred.bloggs@example.com"}
      config_hash_2 = {"address" => "10.0.1.2", "hostname" => "node1.example.com",
                       "role" => "web server"}

      before do
        allow(ConfigItem).to receive(:new).with("global", config_hash_1).and_return(config_item_1)
        allow(ConfigItem).to receive(:new).with("node-1", config_hash_2).and_return(config_item_2)
      end

      it "builds config items from config sections" do
        expected_config_items  = [config_item_1, config_item_2]
        expect(subject.config_items).to eq expected_config_items
      end
    end
  end
end
