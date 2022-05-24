require 'fitting/doc/api'

module Fitting
  class Doc
    class Skip < RuntimeError; end

    class NotFound < RuntimeError; end

    def self.all(yaml)
      yaml['ProvidedAPIs'].map do |host|
        Fitting::Doc::API.new('provided', 'www.example.com', host['prefix'], host['path'])
      end + yaml['UsedAPIs'].map do |host|
        Fitting::Doc::API. new( 'used', host['host'], '', host['path'])
      end
    end

    def self.find!(docs, log)
      docs.find do |doc|
        if doc.type == 'provided' && log.type == 'incoming'
          if log.host == doc.host
            doc.prefix['name'].nil? || log.path[0..prefix['name'].size - 1] == doc.prefix['name']
          end
        elsif doc.type == 'used' && log.type == 'outgoing'
          if log.host == doc.host
            doc.prefix['name'].nil? || log.path[0..prefix['name'].size - 1] == doc.prefix['name']
          end
        end
      end&.find!(log)
    rescue Fitting::Doc::API::NotFound => e
      raise NotFound, e
    end

    def cover!
    end
  end
end
