module Fitting
  class Report
    def initialize(tests)
      @json = {
        'tests' => tests
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
