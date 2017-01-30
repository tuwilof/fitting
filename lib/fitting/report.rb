module Fitting
  class Report
    def initialize(tests)
      documented = {}
      not_documented = {}
      tests.map do |location, test|
        if test['request']['schema'].nil?
          not_documented["#{test['request']['method']} #{test['request']['path']}"] = {}
        else
          code = test['response']['status'].to_s
          valid = test['response']['valid']
          status = "#{test['request']['schema']['method']} #{test['request']['schema']['path']}"
          local_tests = {}
          if documented[status]
            local_tests = documented[status]['responses'][code]['tests']
          end
          unless valid
            local_tests[location] = {
              'reality' => {
                'body' => test['response']['body']
              }
            }
          end

          if local_tests.present?
            valid = false
          end

          documented[status] = {
            'responses' => {
              code => {
                'valid' => valid,
                'tests' => local_tests
              }
            }
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
