require_relative "../configurator"

# No mocking/stubbing
describe Configurator do
  subject { Configurator.new("spec/test_data/config_data") }

  it "gets all values for a given section" do
    expect(subject.values_for_section("node-1")).to eq ["address = 10.0.1.2",
                                                        "hostname = node1.example.com",
                                                        "role = web server"]
  end

  it "gets specific key value" do
    expect(subject.value_for_section_key("global", "email")).to eq "fred.bloggs@example.com"
  end
end
