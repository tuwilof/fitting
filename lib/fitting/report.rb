module Fitting
  class Report
    def initialize(tests)
      documented = {}
      not_documented = {}
      tests.map do |location, test|
        if test['request']['schema'].nil?
          not_documented["#{test['request']['method']} #{test['request']['path']}"] = {}
        else
          documented["#{test['request']['schema']['method']} #{test['request']['schema']['path']}"] = {}
        end
      end
      @json = {
        'tests' => tests,
        'requests' => {
          'documented' => documented,
          'not_documented' => not_documented
        }
      }
    end

    def self.blank
      {
        'tests' => {}
      }
    end

    def to_hash
      @json
    end
  end
end
