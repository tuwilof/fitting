require 'tomograph'

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

    def tomogram
      @tomogram ||= Tomograph::Tomogram.new(
        prefix: @prefix,
        apib_path: @apib_path,
        drafter_yaml_path: @drafter_yaml_path
      )
    end
  end
end
