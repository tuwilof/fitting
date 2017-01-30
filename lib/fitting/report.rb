module Fitting
  class Report
    def initialize
      after_json = {}
      @json = {
        'tests' => after_json
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
