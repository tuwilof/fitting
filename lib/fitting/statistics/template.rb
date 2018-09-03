require 'fitting/statistics/not_covered_responses'
require 'fitting/statistics/analysis'
require 'fitting/statistics/measurement'
require 'fitting/statistics/measurement_cover'
require 'fitting/records/unit/request'
require 'fitting/storage/white_list'
require 'fitting/records/documented/request'

module Fitting
  class Statistics
    class Template
      def initialize(tested_requests, config, depth = 'valid')
        @tested_requests = tested_requests
        @config = config
        @depth = depth
      end

      def save
        File.open(@config.stats_path, 'w') { |file| file.write(stats) }
        File.open(@config.not_covered_path, 'w') { |file| file.write(not_covered) }
      end

      def stats
        if @config.white_list.present? || @config.resource_white_list.present? || @config.include_resources.present?
          [
            ['[Black list]', black_statistics].join("\n"),
            ['[White list]', white_statistics].join("\n"),
            ''
          ].join("\n\n")
        else
          [white_statistics, "\n\n"].join
        end
      end

      def not_covered
        Fitting::Statistics::NotCoveredResponses.new(white_measurement).to_s
      end

      def white_statistics
        @white_statistics ||= Fitting::Statistics::Analysis.new(white_measurement, @depth)
      end

      def black_statistics
        @black_statistics ||= Fitting::Statistics::Analysis.new(black_measurement, @depth)
      end

      def white_measurement
        @white_measurement ||=
          if @depth == 'valid'
            Fitting::Statistics::Measurement.new(white_unit)
          else
            Fitting::Statistics::MeasurementCover.new(white_unit)
          end
      end

      def black_measurement
        @black_measurement ||=
          if @depth == 'valid'
            Fitting::Statistics::Measurement.new(black_unit)
          else
            Fitting::Statistics::MeasurementCover.new(black_unit)
          end
      end

      def white_unit
        @white_unit_requests ||= documented_requests_white.inject([]) do |res, documented_request|
          res.push(Fitting::Records::Unit::Request.new(documented_request, @tested_requests))
        end
      end

      def black_unit
        @black_unit_requests ||= documented_requests_black.inject([]) do |res, documented_request|
          res.push(Fitting::Records::Unit::Request.new(documented_request, @tested_requests))
        end
      end

      def documented_requests_white
        @documented_requests_white ||= documented.find_all(&:white)
      end

      def documented_requests_black
        @documented_requests_black ||= documented.find_all do |request|
          !request.white
        end
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
