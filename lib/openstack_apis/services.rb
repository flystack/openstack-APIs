require 'yaml'

module OpenStackAPIs
  class Service
    require './lib/openstack_apis/webcrawler'
    include OpenStackAPIs::Webcrawler

    attr_reader :name, :desc, :parser, :version, :url
    def initialize(name, desc, parser, version, url)
      @name, @desc, @parser, @version, @url = name, desc, parser, version, url
    end
  end

  class Services
    include Enumerable

    def initialize(file)
      @services = []

      ref = YAML.load_file(file)
      ref.each do |project, details|
        details["versions"].each do |version|
          version.each do |version_key, url|
            @services << Service.new(project, details["name"], :api_ref,  version_key, url)
          end
        end
      end
    end

    def include_only(list)
      @services = @services.select { |service| list.include?(service.name) }
    end

    def fetch
      @services.each { |service| service.fetch }
    end

    def each
      @services.each {|service| yield(service)}
    end
  end
end
