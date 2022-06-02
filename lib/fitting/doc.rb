require 'fitting/doc/action'

module Fitting
  class Doc
    class NotFound < RuntimeError; end

    def self.all(yaml)
      {
        provided: Fitting::Doc::Action.provided_all(yaml['ProvidedAPIs']),
        used: Fitting::Doc::Action.used_all(yaml['UsedAPIs'])
      }
    end

    def self.cover!(docs, log)
      Rails.logger.debug "LOG NAME | #{log.method} #{log.url}"
      if log.type == 'incoming'
        docs[:provided].each do |doc|
          return if doc.cover!(log)
        end
      elsif log.type == 'outgoing'
        docs[:used].each do |doc|
          return if doc.cover!(log)
        end
      end
      Rails.logger.debug "RAISE LOG NAME | #{log.method} #{log.url}"
      raise NotFound
    end
  end
end
