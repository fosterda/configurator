class ConfigItem
  attr_reader :name

  def initialize name, values
    @name = name
    @values = values
  end

  def all_values 
    values_as_strings = []
    @values.to_a.each do |value|
      values_as_strings << value.join(" = ")
    end
    values_as_strings
  end

  def value_of_item key
    @values[key]
  end
end
