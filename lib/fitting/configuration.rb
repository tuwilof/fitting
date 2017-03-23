module Fitting
  class Configuration
    attr_accessor :tomogram,
                  :necessary_fully_implementation_of_responses,
                  :white_list,
                  :create_report_with_name,
                  :strict,
                  :drafter_yaml_path,
                  :prefix,
                  :drafter_yaml,
                  :apib_path

    def initialize
      @necessary_fully_implementation_of_responses = true
      @strict = false
      @prefix = ''
    end
  end
end
