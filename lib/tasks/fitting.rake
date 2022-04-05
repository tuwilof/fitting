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
      prefix.mark!(test)

      action = prefix.actions.find!(test)
      action.mark!(test)

      response = action.responses.find!(test)
      response.mark!(test)

      combination = response.combinations.find!(test)
      combination.mark!(test)
      print "\e[32m.\e[0m"
    rescue Fitting::Report::Combinations::Empty,
      Fitting::Report::Combinations::NotFound,
      Fitting::Report::Actions::Empty
    end

    console = Fitting::Report::Console.new(
      tests.without_prefixes,
      prefixes.to_a.map(&:details)
    )

    puts
    puts
    exit 1 unless console.good?

    exit 0
  end
end
