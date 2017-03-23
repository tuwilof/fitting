module Fitting
  class Configuration
    attr_accessor :apib_path,
                  :drafter_yaml_path,
                  :necessary_fully_implementation_of_responses,
                  :strict,
                  :prefix,
                  :white_list,
                  :create_report_with_name,
                  :tomogram,

    def initialize
      @necessary_fully_implementation_of_responses = true
      @strict = false
      @prefix = ''
    end
  end
end
