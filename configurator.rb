class Configurator

  attr_reader :file_lines, :config_sections

  def initialize filename
    @file_lines = File.read(filename).lines
    @config_sections = build_sections file_lines
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

  def line_is_section_head? line
    !line.match(/^\[.+\]/).nil?
  end

end
