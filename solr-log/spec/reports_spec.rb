require_relative '../lib/reports.rb'
require 'date'

describe Reports::Basic do 
  let(:basic) { Reports::Basic.new(nil,nil) }
  let(:log_line) { "INFO  - 2015-06-14 22:10:02.371; org.apache.solr.core.SolrCore; [csv] webapp=/solr path=/select/ params={indent=true&q=ruby+read+file&hl.simple.pre=<strong>&hl.simple.post=</strong>&hl.fl=description,command:string&hl.fl=description&wt=json&hl=true} hits=56 status=0 QTime=8 " }

  describe '.parse_hits' do
    it "does what it is supposed to" do
      expect(basic.parse_hits(log_line)).to eq("56")
    end
  end

  describe '.parse_query_time' do
    it "does what it is supposed to" do
      expect(basic.parse_query_time(log_line)).to eq("8")
    end
  end

  describe '.parse_status' do
    it "does what it is supposed to" do
      expect(basic.parse_status(log_line)).to eq("0")
    end
  end

  describe '.parse_params' do
    it "does what it is supposed to" do
      expected = {"indent"=>["true"], "q"=>["ruby read file"], "hl.simple.pre"=>["<strong>"], "hl.simple.post"=>["</strong>"], "hl.fl"=>["description,command:string", "description"], "wt"=>["json"], "hl"=>["true}"]}
      expect(basic.parse_params(log_line)).to eq(expected)
    end
  end

  describe '.parse_query' do
    it "does what it is supposed to" do
      expect(basic.parse_query(log_line)).to eq(["ruby", "read", "file"])
    end
  end

  describe '.parse_date' do
    it "does what it is supposed to" do
      expect(basic.parse_date(log_line)).to eq("2015-06-14")
    end
  end

  describe '.parse_time' do
    it "does what it is supposed to" do
      expect(basic.parse_time(log_line)).to eq("22:10:02")
    end
  end

  describe '.parse_datetime' do
    it "does what it is supposed to" do
      expect(basic.parse_datetime(log_line).to_s).to eq(DateTime.parse("2015-06-14 22:10:02.321 PST").to_s)
    end
  end


end
  
