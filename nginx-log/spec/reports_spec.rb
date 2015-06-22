require_relative '../lib/reports.rb'
require 'date'

describe Reports::Basic do 
  let(:basic) { Reports::Basic.new(nil,nil) }
  let(:log_line) { '208.87.61.99 2015-06-19T09:18:53-07:00 200 1144 0.153 0.153 "http://www.greppage.com/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKxit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.115 Safari/537.36" - . "GET /select/?wt=json&hl=true&hl.fl=description,command:string&hl.fl=description&hl.simple.pre=%3Cstrong%3E&hl.simple.post=%3C/strong%3E&q=ruby%20file HTTP/1.1" 
  ' }

  describe '.parse_ip_address' do
    it "does what xit is supposed to" do
      expect(basic.parse_ip_address(log_line)).to eq("208.87.61.99")
    end
  end

  describe '.parse_request_date' do
    it "does what xit is supposed to" do
      expected = DateTime.parse("2015-06-19T09:18:53-07:00")
      expect(basic.parse_request_date(log_line)).to eq(expected)
    end
  end

  describe '.parse_status' do
    it "does what xit is supposed to" do
      expect(basic.parse_status(log_line)).to eq(200)
    end
  end

  describe '.parse_bytes_sent' do
    it "does what xit is supposed to" do
      expect(basic.parse_bytes_sent(log_line)).to eq(1144)
    end
  end

  describe '.parse_request_time' do
    it "does what xit is supposed to" do
      expect(basic.parse_request_time(log_line)).to eq(153)
    end
  end

  describe '.parse_upstream_response_time' do
    it "does what xit is supposed to" do
      expect(basic.parse_upstream_response_time(log_line)).to eq(153)
    end
  end


  describe '.parse_params' do
    it "does what xit is supposed to" do
      expect(basic.parse_params(log_line)).to eq("GET /select/?wt=json&hl=true&hl.fl=description,command:string&hl.fl=description&hl.simple.pre=%3Cstrong%3E&hl.simple.post=%3C/strong%3E&q=ruby%20file HTTP/1.1")
    end
  end

  describe '.parse_http_referrer' do
    it "does what xit is supposed to" do
    end
  end

  describe '.parse_http_user_agent' do
    it "does what xit is supposed to" do
    end
  end
end
  
