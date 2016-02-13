require_relative 'config_item'

class Configurator

  attr_reader :config_items

  def initialize filename
    file_lines = File.read(filename).lines
    config_sections = build_sections file_lines
    @config_items = build_config config_sections
  end

  def values_for_section section_name
    @config_items.each do |config_item|
      return config_item.all_values if config_item.name == section_name
    end
    nil
  end

  def value_for_section_key section_name, key
    @config_items.each do |config_item|
      return config_item.value_of_item(key) if config_item.name == section_name
    end
    nil
  end

  private

  def build_sections lines
    all_sections = []
    section = Array.new

    lines.each do |line|
      if line_is_section_head? line
        # Finish with previous section
        all_sections << section
        section = handle_new_section line
      else
        section << line unless line_is_a_comment? line
      end
    end
    all_sections << section
    all_sections.reject!(&:empty?)
  end

  def line_is_section_head? line
    !line.match(/^\[.+\]/).nil?
  end

  def handle_new_section line
    section = Array.new
    section_name = get_section_name line
    section << section_name
  end

  def get_section_name line
    first_index = line.index("[")
    second_index = line.index("]")
    line[first_index + 1, second_index - 1]
  end

  def line_is_a_comment? line
    !line.match(/^\#.*/).nil?
  end

  def build_config sections
    config = []
    sections.each do |section|
      section_name = section.first
      items = build_config_items section[1..-1]
      config << ConfigItem.new(section_name, items)
    end
    config
  end

  def build_config_items section
    items = {}
    section.each do |item|
      key, value = get_key_and_value_from item
      items[key] = value
    end
    items
  end

  def get_key_and_value_from item
    config_line = item.split("=")
    key = config_line[0].strip
    value = config_line[1].sub(/#.*/, "").strip
    [key, value]
  end

end
