require 'fitting/skip/api'

module Fitting
  class Skip
    def self.all(yaml)
      yaml['SkipProvidedAPIs'].map do |host|
        Fitting::Skip::API.new('provided', 'www.example.com', host['prefix'])
      end + yaml['SkipUsedAPIs'].map do |host|
        Fitting::Skip::API. new( 'used', host['host'], '')
      end
    end

    def self.find(skips, log)
      skips.find do |skip|
        if skip.type == 'provided' && log.type == 'incoming'
          if log.host == skip.host
            skip.prefix['name'].nil? || log.path[0..prefix['name'].size - 1] == skip.prefix['name']
          end
        elsif skip.type == 'used' && log.type == 'outgoing'
          if log.host == skip.host
            skip.prefix['name'].nil? || log.path[0..prefix['name'].size - 1] == skip.prefix['name']
          end
        end
      end
    end
  end
end
