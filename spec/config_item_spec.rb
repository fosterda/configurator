require_relative "../config_item"

describe ConfigItem do
  subject { described_class.new "myName", {"email" => "a.b@example.com", "address" => "here"} }

  it "returns all config values" do
    expect(subject.all_values).to eq ["email = a.b@example.com", "address = here"]
  end
end
