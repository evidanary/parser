require 'cgi'
require 'date'

module Reports
  class Basic
    def initialize(report_start, report_end)
      @queries = {}
      @report_start = report_start
      @report_end = report_end
    end

    # Ndinx log lines look like
    # 208.87.61.99 - - [19/Jun/2015:00:14:39 -0700]  "GET /select/?wt=json&indent=true&hl=true&hl.fl=description,command:string&hl.fl=description&hl.simple.pre=%3Cstrong%3E&hl.simple.post=%3C/strong%3E&q=ruby HTTP/1.1" 502 181 "-" "Apache-HttpClient/4.2.6 (java 1.5)" 0.000 0.000 .

    def parse_log_line(log_line)
    end

    def parse_ip_address(log_line)
      log_line[/^([0-9]{1,3}[\.]){3}[0-9]{1,3}/]
    end

    def parse_request_date(log_line)
      DateTime.parse(log_line.split(" ")[1])
    end
    
    def parse_status(log_line)
      log_line.split(" ")[2].to_i
    end

    def parse_bytes_sent(log_line)
      log_line.split(" ")[3].to_i
    end
    
    def parse_request_time(log_line)
      (log_line.split(" ")[4].to_f * 1000).to_i
    end

    # in milliseconds
    def parse_upstream_response_time(log_line)
      (log_line.split(" ")[5].to_f * 1000).to_i
    end
 

    def parse_http_referrer(log_line)
      true
    end

    def parse_http_user_agent(log_line)
      true
    end

   def parse_params(log_line)
      log_line[/"GET.*$/].strip[1..-2]
    end

 
 end
end
