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
          res += "file: #{key}\n"
          requests.map do |request|
            res += "path: #{request.test_path}\n"
            res += "request: #{request.method} #{request.path} #{request.body}\n"
            res += "response: #{request.response.status} #{request.response.body}\n"
            res += "\n"
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
        @tested_requests.map do |request|
          @test_file_paths[request.test_file_path] ||= []
          @test_file_paths[request.test_file_path].push(request)
        end
        @test_file_paths
      end
    end
  end
end
