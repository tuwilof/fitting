module Fitting
  class YamlConfiguration
    attr_accessor :apib_path,
                  :drafter_yaml_path,
                  :strict,
                  :prefix,
                  :white_list,
                  :resource_white_list,
                  :ignore_list

    def initialize(yaml)
      @apib_path           = yaml['apib_path']
      @drafter_yaml_path   = yaml['drafter_yaml_path']
      @strict              = yaml['strict']
      @prefix              = yaml['prefix']
      @white_list          = yaml['white_list']
      @resource_white_list = yaml['resource_white_list']
      @ignore_list         = yaml['ignore_list']
      default
    end

    private

    def default
      @strict      ||= false if @strict.nil?
      @prefix      ||= ''
      @ignore_list ||= []
    end
  end
end
