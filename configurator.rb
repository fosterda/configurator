require_relative 'config_item'

class Configurator

  attr_reader :file_lines, :config_sections, :config_items

  def initialize filename
    @file_lines = File.read(filename).lines
    @config_sections = build_sections file_lines
    @config_items = build_config @config_sections
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
    sections.each do |sect|
      items = {}
      sect[1..-1].each do |item|
        config_line = item.split("=")
        key = config_line[0].strip
        value = config_line[1].sub(/#.*/, "").strip
        items[key] = value
      end
      config << ConfigItem.new(sect.first, items)
    end
    config
  end

end
