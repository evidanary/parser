require 'trollop'
require 'json'
require 'csv'
require_relative './free_text_parser.rb'
require_relative './state_machine.rb'

class Run
  def initialize(fileout, filein)
    @fileout = fileout
    @filein = filein
  end

  # e.g. hdfs# should be converted to hdfs
  def remove_special_characters(input) 
    removal_regex = /[^[a-zA-Z0-9_ ]]/
    normalize_space_regex = /\s+/
    input.gsub(removal_regex,'').gsub(normalize_space_regex, ' ').strip
  end
  
  # e.g. hdfs hdfs streaming should be "hdfs streaming"
  def remove_repeating_words(input) 
    input.downcase.split(" ").uniq.join(" ")
  end
 
  def run_yash_model
    parser = FreeTextParser.new
    model = YashCheatSheetParseModel.new(parser)
    File.open(@filein,"r").each do |line|
      puts "READING: #{line}"
      model.handle_event(parser.inspect(line).first)
    end


#    CSV.open(@fileout,"wb") do |csv|
#      csv << ["id","section","description","command"]
#      parser.result_cheat_array.each_with_index do |cheat,idx|
#        csv << ["#{idx}#{cheat.category}" || "",
#                cheat.category || "",
#                cheat.description || "",
#                cheat.command || ""]
#      end
#    end

    File.open(@fileout, 'wb') do |file|
      cheat_hash_array = []
      parser.result_cheat_array.each_with_index do |cheat,idx|
        cheat_hash = {}
	cheat_hash[:id] = [idx, cheat.category].join || ""
        cheat_hash[:section] = remove_special_characters(cheat.category) || ""
        cheat_hash[:description] = cheat.description || ""
        cheat_hash[:command] = cheat.command.join("\n") || ""
	cheat_hash[:textSuggest] = remove_repeating_words([cheat_hash[:section], cheat_hash[:description]].join(" "))
	
	cheat_hash_array << cheat_hash
      end
      file.write(cheat_hash_array.to_json)
    end

    puts parser.result_cheat_array.map {|x| puts x.inspect}[1..10]
    puts parser.result_cheat_array.count
  end
end

opts = Trollop::options do
  opt :filein , "File in", :type => :string, :required => true
  opt :fileout , "File out", :type => :string, :required => true
end

runner = Run.new(opts[:fileout], opts[:filein])
runner.run_yash_model
