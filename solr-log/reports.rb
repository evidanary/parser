require 'cgi'
require 'date'

module Reports
  class Basic
    def initialize(report_start, report_end)
      @queries = {}
      @report_start = report_start
      @report_end = report_end
    end

    # Solr log lines look like
    # INFO  - 2015-06-14 22:10:02.371; org.apache.solr.core.SolrCore; [csv] webapp=/solr path=/select/ params={indent=true&q=ruby+read+file&hl.simple.pre=<strong>&hl.simple.post=</strong>&hl.fl=description,command:string&hl.fl=description&wt=json&hl=true} hits=56 status=0 QTime=8 
    def parse_log_line(log_line)
      hits = parse_hits(log_line)
      query_time = parse_query_time(log_line)
      status = parse_status(log_line)
      params = parse_params(log_line)

    end

    def parse_hits(log_line)
      log_line[/\shits=\K\d+/]
    end

    def parse_query_time(log_line)
      log_line[/\sQTime=\K\d+/]
    end

    def parse_status(log_line)
      log_line[/\sstatus=\K\d+/]
    end

    def parse_params(log_line)
      CGI::parse(log_line[/\sparams={\K.*}\s/][0..-2])
    end
    
    def parse_query(log_line)
      parse_params(log_line)["q"].first.split(" ")
    end

    def parse_date(log_line)
      log_line[/\d{4}-\d{1,2}-\d{1,2}/]
    end

    def parse_time(log_line)
      log_line[/\d{1,2}:\d{1,2}:\d{1,2}/]
    end

    def parse_datetime(log_line)
      DateTime.parse([parse_date(log_line),
                      parse_time(log_line),
		      "PST"].join(" "))
    end
  end
end
