require 'HTTParty'
require "addressable/uri"

class GrepPage

  def initialize(base_uri)
    @base_uri = base_uri
  end

  def get(params, path = 'select')
    uri = Addressable::URI.new
    uri.query_values = params
    request_uri = [@base_uri, '/',  path, '?', uri.query].join
    puts "Processing Request URI: #{request_uri}"
    HTTParty.get(request_uri)
  end

  def post()
  end
end
