require 'fitting/skip/api'
require 'fitting/skip/action'

module Fitting
  class Skip
    def self.all
      yaml = YAML.safe_load(File.read('.fitting.yml'))
      {
        apis: Fitting::Skip::API.all(yaml['SkipAPIs']),
        actions: Fitting::Skip::Action.all(yaml['SkipAPIs'])
      }
    end

    def self.find(skips, log)
      api = Fitting::Skip::API.find(skips[:apis], log)
      return api if api

      Fitting::Skip::Action.find(skips[:actions], log)
    end
  end
end
