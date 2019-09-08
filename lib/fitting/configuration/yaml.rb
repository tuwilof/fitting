require 'tomograph'

module Fitting
  class Configuration
    class Yaml
      attr_reader   :title
      attr_accessor :apib_path,
                    :drafter_yaml_path,
                    :crafter_apib_path,
                    :crafter_yaml_path,
                    :drafter_4_apib_path,
                    :drafter_4_yaml_path,
                    :tomogram_json_path,
                    :strict,
                    :prefix,
                    :white_list,
                    :resource_white_list,
                    :ignore_list,
                    :include_resources,
                    :include_actions

      def initialize(yaml, title = 'fitting')
        @apib_path = yaml['apib_path']
        @drafter_yaml_path = yaml['drafter_yaml_path']
        @crafter_apib_path = yaml['crafter_apib_path']
        @crafter_yaml_path = yaml['crafter_yaml_path']
        @drafter_4_apib_path = yaml['drafter_4_apib_path']
        @drafter_4_yaml_path = yaml['drafter_4_yaml_path']
        @tomogram_json_path = yaml['tomogram_json_path']
        @strict = yaml['strict']
        @prefix = yaml['prefix']
        @white_list = yaml['white_list']
        @resource_white_list = yaml['resource_white_list']
        @ignore_list = yaml['ignore_list']
        @include_resources = yaml['include_resources']
        @include_actions = yaml['include_actions']
        @title = title
        default
      end

      def tomogram
        @tomogram ||= if @crafter_yaml_path || @crafter_apib_path
                        Tomograph::Tomogram.new(
                          prefix: @prefix,
                          crafter_apib_path: @crafter_apib_path,
                          crafter_yaml_path: @crafter_yaml_path,
                        )
                      elsif @drafter_4_apib_path || @drafter_4_yaml_path
                        Tomograph::Tomogram.new(
                          prefix: @prefix,
                          drafter_4_apib_path: @drafter_4_apib_path,
                          drafter_4_yaml_path: @drafter_4_yaml_path,
                        )
                      else
                        Tomograph::Tomogram.new(
                          prefix: @prefix,
                          apib_path: @apib_path,
                          drafter_yaml_path: @drafter_yaml_path,
                          tomogram_json_path: @tomogram_json_path
                        )
                      end
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
        @strict ||= false if @strict.nil?
        @prefix ||= ''
        @ignore_list ||= []
      end
    end
  end
end
