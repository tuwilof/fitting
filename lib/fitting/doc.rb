require 'fitting/doc/provided_api'
require 'fitting/doc/used_api'

module Fitting
  class Doc
    class Skip < RuntimeError; end

    class NotFound < RuntimeError; end

    def self.all(yaml)
      Fitting::Doc::ProvidedAPI.all(yaml) + Fitting::Doc::UsedAPI.all(yaml)
    end

    def self.find!(docs, log)
      docs.find do |doc|
        if doc.class == Fitting::Doc::ProvidedAPI && log.type == 'incoming'
          if log.host == doc.host
            doc.prefix['name'].nil? || log.path[0..prefix['name'].size - 1] == doc.prefix['name']
          end
        elsif doc.class == Fitting::Doc::UsedAPI && log.type == 'outgoing'
          if log.host == doc.host
            doc.prefix['name'].nil? || log.path[0..prefix['name'].size - 1] == doc.prefix['name']
          end
        end
      end&.find!(log)
    rescue Fitting::Doc::UsedAPI::NotFound, Fitting::Doc::ProvidedAPI::NotFound => e
      raise NotFound, e
    end

    def cover!
    end
  end
end
