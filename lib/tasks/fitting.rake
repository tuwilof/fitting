require 'fitting/log'
require 'fitting/host'
require 'fitting/prefix'
require 'fitting/report/prefixes'

namespace :fitting do
  task :report do
    logs = Fitting::Log.all
    errors = []

    logs.map do |log|
      host = Fitting::Host.find!(log)
      host.cover!

      prefix = Fitting::Prefix.find(host: host, log: log)
      prefix.cover!

      action = prefix.actions.find!(log)
      action.cover!

      response = action.responses.find!(log)
      response.cover!

      combination = response.combinations.find!(log)
      combination.cover!
      print "\e[32m.\e[0m"
    rescue Fitting::Report::Actions::Empty,
      Fitting::Host::Skip,
      Fitting::Prefix::Skip
      print "\e[33m*\e[0m"
    rescue Fitting::Report::Combinations::Empty,
      Fitting::Report::Combinations::NotFound
    rescue Fitting::Host::NotFound,
      Fitting::Prefix::NotFound,
      Fitting::Report::Actions::NotFound,
      Fitting::Report::Responses::NotFound => e
      errors.push(e)
      print "\e[31mF\e[0m"
    end

    puts
    errors.each_with_index do |error, index|
      puts "\e[31m"\
           "  #{index+1}) #{error.class} #{error.message}\n"\
            "\e[0m"
    end

    all = 0
    cover = 0
    logs
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
