require 'fitting/route'
require 'fileutils'

module Fitting
  class Statistics
    def initialize(documentation, all_responses, strict)
      @documentation = documentation
      @black_route = Fitting::Route.new(all_responses, @documentation.black, strict)
      @white_route = Fitting::Route.new(all_responses, @documentation.white, strict)
    end

    def save
      FileUtils.mkdir_p 'fitting'
      File.open('fitting/stats', 'w') { |file| file.write(to_s) }
      File.open('fitting/not_covered', 'w') { |file| file.write(@white_route.errors) }
    end

    def cover_save
      @white_route.cover_save
    end

    def to_s
      if @documentation.black.any?
        [
          ['[Black list]', @black_route.statistics_with_conformity_lists].join("\n"),
          ['[White list]', @white_route.statistics_with_conformity_lists].join("\n"),
          ''
        ].join("\n\n")
      else
        [@white_route.statistics_with_conformity_lists, "\n\n"].join
      end
    end
  end
end
