require 'trollop'
require_relative 'reports.rb'

# Usage --logfile --start-date --report
# Output <query>

opts = Trollop::options do 
  opt :log_file, "solr log file to parse", :type => :string
  opt :start_date, "start date of the query", :type => :date
  opt :end_date, "end date of the query", :type => :date, :required => false
end

report = Reports::Basic.new(opts[:start_date], opts[:end_date])
IO.foreach(opts[:log_file]) do |log_line|
  if log_line[/INFO.*path=\/select/]
    if (Date.parse(report.parse_date(log_line)) >= opts[:start_date])
      puts report.parse_query(log_line).join(" ")
    end
  end
end
