require 'fitting/records/test_unit/request'

module Fitting
  class Statistics
    class TestTemplate
      def initialize(tested_requests, config)
        @tested_requests = tested_requests
        @config = config
      end

      def save
        File.open('fitting/tests_stats', 'w') { |file| file.write(stats) }
        File.open('fitting/tests_not_covered', 'w') { |file| file.write(not_covered) }
      end

      def stats
        res = ''
        test_file_paths.each do |key, requests|
          all_good = requests.all? { |request| request.documented? }
          res += "file: #{key} #{all_good ? '✔' : '✖'}\n"
          requests.map do |request|
            res += "path: #{request.test_path} #{request.documented? ? '✔' : '✖'}\n"
            res += "request: #{request.method} #{request.path} #{request.body}\n"
            res += "response: #{request.response.status} #{request.response.body}\n"
          end
          res += "\n"
        end
        res
      end

      def not_covered
        "\n"
      end

      def test_file_paths
        return @test_file_paths if @test_file_paths
        @test_file_paths = {}
        white_unit.map do |request|
          if request.path.to_s.start_with?(@config.prefix)
            @test_file_paths[request.test_file_path] ||= []
            @test_file_paths[request.test_file_path].push(request)
          end
        end
        @test_file_paths
      end

      def all_documented_requests
        @all_documented_requests ||= @config.tomogram.to_hash.inject([]) do |res, tomogram_request|
          res.push(Fitting::Records::Documented::Request.new(tomogram_request, nil))
        end
      end

      def white_unit
        @white_unit_requests ||= @tested_requests.inject([]) do |res, tested_request|
          res.push(Fitting::Records::TestUnit::Request.new(tested_request, all_documented_requests))
        end
      end
    end
  end
end
