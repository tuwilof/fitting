require 'fitting/host'
require 'fitting/prefix'
require 'fitting/report/prefixes'

module Fitting
  class Action
    class Skip < RuntimeError; end
    class Empty < RuntimeError; end
    class NotFound < RuntimeError
      attr_reader :log

      def initialize(msg, log)
        @log = log
        super(msg)
      end
    end

    def initialize(action)
      @action = action
    end

    def action
      @action
    end

    def self.all
      []
    end

    def self.find!(actions, log)
      host = Fitting::Host.find!(log)
      host.cover!

      prefix = Fitting::Prefix.find(host: host, log: log)
      prefix.cover!

      new(prefix.actions.find!(log))
    rescue Fitting::Report::Actions::Empty,
      Fitting::Host::Skip,
      Fitting::Prefix::Skip
      raise Skip
    rescue Fitting::Report::Combinations::Empty,
      Fitting::Report::Combinations::NotFound
      raise Skip
    rescue Fitting::Host::NotFound,
      Fitting::Prefix::NotFound,
      Fitting::Report::Actions::NotFound,
      Fitting::Report::Responses::NotFound => e
      raise NotFound.new(e.message, log)
    end

    def cover!(log)
      action.cover!

      response = action.responses.find!(log)
      response.cover!

      combination = response.combinations.find!(log)
      combination.cover!

      print "\e[32m.\e[0m"
    rescue Fitting::Report::Actions::Empty,
      Fitting::Host::Skip,
      Fitting::Prefix::Skip
    rescue Fitting::Report::Combinations::Empty,
      Fitting::Report::Combinations::NotFound
    rescue Fitting::Host::NotFound,
      Fitting::Prefix::NotFound,
      Fitting::Report::Actions::NotFound,
      Fitting::Report::Responses::NotFound => e
    end

    def self.report(actions)
      all = 0
      cover = 0

      # prefixes.to_a.map do |prefix|
      #   all += 1
      #   break unless prefix.cover?
      #   cover += 1
      #   prefix.actions.to_a.map do |action|
      #     all += 1
      #     break unless action.cover?
      #     cover += 1
      #     action.responses.to_a.map do |response|
      #       all += 1
      #       break unless action.cover?
      #       cover += 1
      #       response.combinations.to_a.map do |combination|
      #         all += 1
      #         break unless combination.cover?
      #         cover += 1
      #       end
      #     end
      #   end
      # end

      puts
      puts "Coverage #{(cover.to_f / all.to_f * 100).round(2)}%"
      exit 1 unless false

      exit 0
    end
  end
end
