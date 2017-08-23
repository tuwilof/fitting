module Fitting
  class Configuration
    attr_accessor :apib_path,
                  :drafter_yaml_path,
                  :strict,
                  :prefix,
                  :white_list,
                  :resource_white_list,
                  :ignore_list

    def initialize
      @strict = false
      @prefix = ''
      @ignore_list = []
    end
  end
end
