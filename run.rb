require 'trollop'
require 'csv'
require_relative './free_text_parser.rb'
require_relative './state_machine.rb'

class Run
  def initialize(fileout, filein)
    @fileout = fileout
    @filein = filein
  end


  def run_yash_model
    parser = FreeTextParser.new
    model = YashCheatSheetParseModel.new(parser)
    File.open(@filein,"r").each do |line|
      puts "READING: #{line}"
      model.handle_event(parser.inspect(line).first)
    end


    CSV.open(@fileout,"wb") do |csv|
      csv << ["id","section","description","command"]
      parser.result_cheat_array.each_with_index do |cheat,idx|
        csv << ["#{idx}#{cheat.category}" || "",
                cheat.category || "",
                cheat.description || "",
                cheat.command || ""]
      end
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
