module Fitting
  class Statistics
    class TestTemplate
      def save
        File.open('fitting/tests_stats', 'w') { |file| file.write('tests_stats') }
        File.open('fitting/tests_not_covered', 'w') { |file| file.write("\n") }
      end
    end
  end
end
