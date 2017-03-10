module Fitting
  class Configuration
    attr_accessor :tomogram,
                  :necessary_fully_implementation_of_responses,
                  :white_list

    def initialize
      @necessary_fully_implementation_of_responses = true
    end
  end
end
