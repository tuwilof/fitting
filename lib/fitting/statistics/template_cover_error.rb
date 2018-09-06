require 'fitting/statistics/cover_error'
require 'fitting/records/unit/request'
require 'fitting/storage/white_list'
require 'fitting/records/documented/request'

module Fitting
  class Statistics
    class TemplateCoverError
      def initialize(tested_requests, config)
        @tested_requests = tested_requests
        @config = config
      end

      def stats
        "#{white_statistics}\n\n"
      end


      def white_statistics
        @white_statistics ||= Fitting::Statistics::CoverError.new(white_unit)
      end

      def white_unit
        @white_unit_requests ||= documented_requests_white.inject([]) do |res, documented_request|
          res.push(Fitting::Records::Unit::Request.new(documented_request, @tested_requests))
        end
      end

      def documented_requests_white
        @documented_requests_white ||= documented.find_all(&:white)
      end

      def documented
        @documented_requests ||= @config.tomogram.to_a.inject([]) do |res, tomogram_request|
          res.push(Fitting::Records::Documented::Request.new(tomogram_request, white_list.to_a))
        end
      end

      def white_list
        @white_list ||= Fitting::Storage::WhiteList.new(
          @config.prefix,
          @config.white_list,
          @config.resource_white_list,
          @config.include_resources,
          @config.include_actions,
          @config.tomogram.to_resources
        )
      end
    end
  end
end
