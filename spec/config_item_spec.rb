require_relative "../config_item"

describe ConfigItem do
  subject { described_class.new "myName", {"email" => "a.b@example.com", "address" => "here"} }

  it "returns all config values" do
    expect(subject.all_values).to eq ["email = a.b@example.com", "address = here"]
  end

  it "returns the value for a specific key" do
    expect(subject.value_of_item("email")).to eq "a.b@example.com"
  end
end
