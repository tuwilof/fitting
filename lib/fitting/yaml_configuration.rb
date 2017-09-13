require 'tomograph'

module Fitting
  class YamlConfiguration
    attr_accessor :apib_path,
                  :drafter_yaml_path,
                  :strict,
                  :prefix,
                  :white_list,
                  :resource_white_list,
                  :ignore_list

    def initialize(yaml, title = 'fitting.yml')
      @apib_path           = yaml['apib_path']
      @drafter_yaml_path   = yaml['drafter_yaml_path']
      @strict              = yaml['strict']
      @prefix              = yaml['prefix']
      @white_list          = yaml['white_list']
      @resource_white_list = yaml['resource_white_list']
      @ignore_list         = yaml['ignore_list']
      @title               = title
      default
    end

    def tomogram
      @tomogram ||= Tomograph::Tomogram.new(
        prefix: @prefix,
        apib_path: @apib_path,
        drafter_yaml_path: @drafter_yaml_path
      )
    end

    def title
      @title
    end

    def stats_path
      if @title == 'fitting'
        'fitting/stats'
      else
        "fitting/#{@title}/stats"
      end
    end

    def not_covered_path
      if @title == 'fitting'
        'fitting/not_covered'
      else
         "fitting/#{@title}/not_covered"
      end
    end

    private

    def default
      @strict      ||= false if @strict.nil?
      @prefix      ||= ''
      @ignore_list ||= []
    end
  end
end
