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
      new
    end

    def cover!
    end
  end
end
