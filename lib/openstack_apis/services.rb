require './lib/openstack_apis/service'

module OpenStackAPIs
  class Services
    include Enumerable

    def initialize(file)
      @services = []

      ref = YAML.load_file(file)
      ref.each do |project, details|
        details["versions"].each do |version|
          version.each do |version_key, url|
            @services << OpenStackAPIs::Service.new(project, details["name"], :api_ref,  version_key, url)
          end
        end
      end
    end

    def include_only(list)
      @services = @services.select { |service| list.include?(service.name) }
    end


    def fetch(base)
      @services.each do |service|
        project_path = "#{base}/#{service.name}"
        target = "#{project_path}/#{service.version}.yaml"
        Dir.mkdir(project_path) unless Dir.exist?(project_path)
        puts "Fetching #{service.name} -> #{service.version}"
        File.write(target, service.fetch.to_yaml)
      end
    end

    def each
      @services.each {|service| yield(service)}
    end
  end
end
