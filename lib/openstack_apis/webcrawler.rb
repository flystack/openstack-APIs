require 'nokogiri'
require 'open-uri'

module OpenStackAPIs
  module Webcrawler
    def add_method_name(verb, path)
      if elements?(path)
        subpath = /(.*)(\{.*\})(.*)/.match(path)
        case verb
        when /get/
          "show_"
        when /delete/
          "delete_"
        when /post/
          "create_"
        when /put/
          "update_"
        else
          raise SyntaxError
        end
      else
        word = path.split('/')[-1]
        case verb
        when /get/
          "list_#{word}"
        when /post/
          "create_#{word}"
        when /put/
          "create_#{word}"
        when /delete/
          "delete_#{word}"
        else
          raise SyntaxError
        end
      end
    end

    def api_ref(page)
      api = {}
      group = page.css("div.detail-control").select
      group.each do |e|
        verb = e.css("div.operation").css("span.label")[0].text.to_sym
        cont = e.css("div.endpoint-container").css("div.row").select
        details = []
        cont.each do |e|
          details << e.text
        end

        name = e["id"].gsub(/-/, '_').to_sym
        request = { verb => [ name ]}
        path = details[0]

        if api.has_key?(path)
          if api[path].has_key?(verb)
            api[path][verb] << name
          else
            api[path].merge!(request)
          end
        else
          api[path] = request
        end
      end
      api
    end

    # For Legacy pages
    def api_web(page)
      list = []
      group = page.css("div.section").select
      group.each do |section|
        %w{get put post delete}.each do |verb|
          op = section.css("dl.#{verb}").select
          op.each do |req|
            request = req.css("dt")[0].attributes['id'].value
            list << request unless list.include?(request)
          end
        end
      end
      api = {}
      list.each do |item|
        item.gsub!('--','--/')
        verb, path = item.split("--")
        path.gsub!('-','/')
        path.gsub!('(','{')
        path.gsub!(')','}')
        if api[path]
          # Add request to existing path
          api[path].merge!(verb.upcase.to_sym => [add_method_name(verb, path).to_sym])
        else
          # Add new path with request
          api.merge!(path => {verb.upcase.to_sym => [add_method_name(verb, path).to_sym]})
        end
      end
      api
    end

    def elements?(path)
      return true if path =~ /(.*)(\{.*\})(.*)/
    end
  end
end
