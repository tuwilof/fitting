require 'fitting/skip/api'
require 'fitting/skip/action'

module Fitting
  class Skip
    def self.all(yaml)
      {
        apis: Fitting::Skip::API.all(yaml),
        actions: Fitting::Skip::Action.all(yaml)
      }
    end

    def self.find(skips, log)
      api = Fitting::Skip::API.find(skips[:apis], log)
      return api if api

      Fitting::Skip::Action.find(skips[:actions], log)
    end
  end
end
