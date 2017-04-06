module Fitting
  class Configuration
    attr_accessor :apib_path,
                  :drafter_yaml_path,
                  :strict,
                  :prefix,
                  :white_list,
                  :create_report_with_name,
                  :tomogram

    def initialize
      @strict = false
      @prefix = ''
    end
  end
end
