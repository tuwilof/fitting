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
      if log.type == 'incoming'
        docs[:provided].each do |doc|
          return if doc.cover!(log)
        end
      elsif log.type == 'outgoing'
        docs[:used].each do |doc|
          return if doc.cover!(log)
        end
      end
      raise NotFound.new "log type: #{log.type}\n\n#{log.method} #{log.host} #{log.url} #{log.status} #{log.type}"
    rescue Fitting::Doc::Action::NotFound => e
      raise NotFound.new "log type: #{log.type}\n\n"\
          "#{e.message}"
    end

    def self.debug(docs, debug)
      (docs[:provided] + docs[:used]).each do |doc|
        res = doc.debug(debug)
        return res if res
      end
      raise NotFound
    end

    def self.report(docs)
      all = 0
      cov = 0
      docs[:provided].each do |provid|
        provid.to_hash.values.first.each do |prov|
          if prov == nil
            break
          elsif prov == 0
            all += 1
          elsif prov > 0
            all += 1
            cov += 1
          end
        end
      end
      docs[:used].each do |provid|
        provid.to_hash.values.first.each do |prov|
          if prov == nil
            break
          elsif prov == 0
            all += 1
          elsif prov > 0
            all += 1
            cov += 1
          end
        end
      end
      res = (cov.to_f / all.to_f * 100).round(2)
      puts "Coverage: #{res}%"
      if res == 100.00
        exit 0
      else
        exit 1
      end
    end
  end
end
