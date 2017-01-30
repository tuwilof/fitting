module Fitting
  class Report
    def initialize(tests)
      documented = {}
      not_documented = {}
      tests.map do |location, test|
        if test['request']['schema'].nil?
          not_documented["#{test['request']['method']} #{test['request']['path']}"] = {}
        else
          valid = test['response']['valid']
          status = "#{test['request']['schema']['method']} #{test['request']['schema']['path']}"

          if documented[status] && documented[status]['valid'] && !valid
            valid = true
          end

          local_tests = []
          if documented[status]
            local_tests = documented[status]['tests']
          end
          local_tests.push(location)

          documented[status] = {
            'valid' => valid,
            'tests' => local_tests
          }
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
