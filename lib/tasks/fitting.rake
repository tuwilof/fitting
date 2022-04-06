require 'fitting/cover/json_schema'
require 'fitting/report/prefixes'
require 'fitting/report/tests'
require 'fitting/report/console'

namespace :fitting do
  task :report do
    tests = Fitting::Report::Tests.new_from_config
    prefixes = Fitting::Report::Prefixes.new(Fitting.configuration.prefixes)

    tests.to_a.map do |test|
      prefix = prefixes.find!(test)
      prefix.cover!

      action = prefix.actions.find!(test)
      action.cover!

      response = action.responses.find!(test)
      response.cover!

      combination = response.combinations.find!(test)
      combination.cover!
      print "\e[32m.\e[0m"
    rescue  Fitting::Report::Actions::Empty
      print "\e[33m*\e[0m"
    rescue Fitting::Report::Combinations::Empty,
      Fitting::Report::Combinations::NotFound
    end

    all = 0
    cover = 0
    prefixes.to_a.map do |prefix|
      all += 1
      break unless prefix.cover?
      cover += 1
      prefix.actions.to_a.map do |action|
        all += 1
        break unless action.cover?
        cover += 1
        action.responses.to_a.map do |response|
          all += 1
          break unless action.cover?
          cover += 1
          response.combinations.to_a.map do |combination|
            all += 1
            break unless combination.cover?
            cover += 1
          end
        end
      end
    end

    puts
    puts "Coverage #{(cover.to_f /  all.to_f * 100).round(2)}%"
    exit 1 unless false

    exit 0
  end
end
