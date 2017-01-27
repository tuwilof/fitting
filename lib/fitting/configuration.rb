module Fitting
  class Configuration
    attr_accessor :tomogram,
                  :skip_not_documented,
                  :validation_requests,
                  :validation_response

    def initialize
      @skip_not_documented = true
      @validation_requests = true
      @validation_response = true
    end
  end
end
