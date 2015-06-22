require 'trollop'
require_relative 'reports.rb'

# Usage --logfile= --start-date= --report=
# Output <query>

opts = Trollop::options do 
  opt :log_file, "nginx log file to parse", :type => :string, :required => true
  opt :start_date, "start date of the request", :type => :date
  opt :end_date, "end date of the query(not implemented)", :type => :date, :required => false
  opt :status, "get the status of each log line"
  opt :request_time, "get the response time in milliseconds"
end

report = Reports::Basic.new(opts[:start_date], opts[:end_date])
IO.foreach(opts[:log_file]) do |log_line|
  if log_line[/GET/]
    if (opts[:start_date].nil? || report.parse_request_date(log_line) >= opts[:start_date])
      puts report.parse_status(log_line) if opts[:status]
      puts report.parse_request_time(log_line)  if opts[:request_time]
    end
  end
end
