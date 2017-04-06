module Fitting
  class Configuration
    attr_accessor :apib_path,
                  :drafter_yaml_path,
                  :strict,
                  :prefix,
                  :white_list,
                  :create_report_with_name,
                  :tomogram,
                  :show_statistics_in_console

    def initialize
      @strict = false
      @prefix = ''
      @show_statistics_in_console = true
    end
  end
end
