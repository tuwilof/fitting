module Fitting
  class Configuration
    attr_accessor :tomogram,
                  :crash_not_implemented_response

    def initialize
      @crash_not_implemented_response = true
    end
  end
end
