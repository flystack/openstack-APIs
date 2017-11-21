require './lib/openstack_apis/webcrawler'
require 'yaml'

module OpenStackAPIs
  class Service
    include OpenStackAPIs::Webcrawler

    attr_reader :name, :desc, :parser, :version, :url

    def initialize(name, desc, parser, version, url)
      @name, @desc, @parser, @version, @url = name, desc, parser, version, url
    end

    def fetch
      return if @url.empty?
      html_source = fetch_source(@url)
      return self.send(@parser, html_source)
    end

    def fetch_source(url)
      raise Error, "No URL source" if url.empty?
      return Nokogiri::HTML(open(url))
    end
  end
end
