require_relative './cheat.rb'
class FreeTextParser
  attr_reader :result_cheat_array
  def initialize
    @current_category = nil
    @current_cheat = nil
    @current_line = nil
    @result_cheat_array = []
  end

  def inspect(line)
    @current_line = line
    classes = []
    classes << :visual_separator if line[/^\#{3,}$/]
    classes << :ends_with_hash_character if line[/\w+\#$/]
    classes << :blank_line if line.strip[/^$/]
    classes << :text_line if line[/\S+/]

    classes
  end

  def set_category
    @current_category = @current_line.strip
  end


  def set_description
    @current_cheat = Cheat.new
    @current_cheat.category = @current_category
    @current_cheat.description = @current_line.strip
    @current_cheat.command = []
  end

  def set_command
    @current_cheat.command << @current_line.gsub(/\s+$/,'')
  end

  def finalize_cheat
    @result_cheat_array << @current_cheat
  end
end
