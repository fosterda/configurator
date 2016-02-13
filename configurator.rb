class Configurator

  attr_reader :file_lines

  def initialize filename
    @file_lines = File.read(filename).lines

    
  end
end
