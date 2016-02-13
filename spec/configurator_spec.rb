require_relative "../configurator"

describe Configurator do
  context "config file doesn't exist" do
    it "raises Exception" do
      expect{described_class.new("non_existent_file")}.to raise_exception(Exception)
    end
  end

  context "config file exists" do
    subject { described_class.new "spec/test_data/config_data"}

    it "returns lines from config file" do
      expected_lines = ["[global]\n", "  username= fred\n", "  email = fred.bloggs@example.com\n", 
       "# Node definitions\n", "[node-1]\n", "  address = 10.0.1.2\n", 
       "  hostname = node1.example.com\n", "  role =  web server # backup\n"]
      expect(subject.file_lines).to eq expected_lines
    end
  end
end
