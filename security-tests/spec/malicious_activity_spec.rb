# This class tests if the webserver (nginx) that proxies traffic to solr
# prevents malicious requests
require '../lib/greppage.rb'
require './rspec_config.rb'
require 'multi_json'

describe "MaliciousActivityTest" do 
  let(:safe_request) { { :q => "ruby read file", :wt => "json" } }
  let(:dev_base_uri) { "http://127.0.0.1" }
  #let(:dev_base_uri) { "http://www.greppage.com" }
  let(:page) { GrepPage.new(dev_base_uri) }
  let(:safe_request_1) { "INFO  - 2015-06-14 22:10:02.371; org.apache.solr.core.SolrCore; [csv] webapp=/solr path=/select/ params={indent=true&q=ruby+read+file&hl.simple.pre=<strong>&hl.simple.post=</strong>&hl.fl=description,command:string&hl.fl=description&wt=json&hl=true} hits=56 status=0 QTime=8 " }
  
  describe 'test if server returns good queries' do
    let(:response) { page.get(safe_request) }
    it "returns 200 for a safe request" do
      expect(response.code).to eq(200)
    end
    it "returns at least one result for a safe request" do
      num_found = MultiJson.load(response.body, :symbolize_keys => true)[:response][:numFound]
      expect(num_found).to be > 0
    end
  end

  describe 'test if server returns expected for bad input' do
    let(:unsafe_request) { { :wt => "json"} }
 
    it "returns 10 rows for requesting more than 10 rows" do
      unsafe_request[:q] = "ruby"
      unsafe_request[:rows] = 11
      expect(rows_received(unsafe_request)).to eq(10)
    end

    it "returns 10 rows for requesting integer max rows" do
      unsafe_request[:q] = "ruby"
      unsafe_request[:rows] = 2147483647
      expect(rows_received(unsafe_request)).to eq(10)
    end

    it "returns 10 rows for requesting for a ridiculously high number" do
      unsafe_request[:q] = "ruby"
      unsafe_request[:rows] = 2147483647123514512341245145
      expect(rows_received(unsafe_request)).to eq(10)
    end


   it "returns first page when requesting beyond first 10 results" do
      unsafe_request[:q] = "ruby"
      unsafe_request[:start] = 11
      response = page.get(unsafe_request)
      start = MultiJson.load(response.body, :symbolize_keys => true)[:response][:start]
      expect(start).to eq(0)
    end
 
  end

  def rows_received(request)
    response = page.get(request)
    MultiJson.load(response.body, :symbolize_keys => true)[:response][:docs].length
  end
end 

