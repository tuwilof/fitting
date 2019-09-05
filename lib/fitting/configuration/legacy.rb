require 'tomograph'

module Fitting
  class Configuration
    class Legacy
      attr_accessor :apib_path,
                    :drafter_yaml_path,
                    :strict,
                    :prefix,
                    :white_list,
                    :resource_white_list,
                    :ignore_list,
                    :include_resources,
                    :include_actions

      def initialize
        @strict = false
        @prefix = ''
        @ignore_list = []
      end

      def tomogram
        @tomogram ||= if @crafter_yaml_path
                        Tomograph::Tomogram.new(
                          prefix: @prefix,
                          apib_path: @apib_path,
                          crafter_yaml_path: @crafter_yaml_path
                        )
                      else Tomograph::Tomogram.new(
                        prefix: @prefix,
                        apib_path: @apib_path,
                        drafter_yaml_path: @drafter_yaml_path
                      )
                      end
      end

      def title
        'fitting'
      end

      def stats_path
        'fitting/stats'
      end

      def not_covered_path
        'fitting/not_covered'
      end
    end
  end
end
