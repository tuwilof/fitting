module Fitting
  class Templates
    class RealizedTemplate
      def initialize(realized_unit)
        @realized_unit = realized_unit
      end

      def to_s
        res = ''
        res += "1. Find request method and path:\n"
        @realized_unit.test_file_paths.each do |key, requests|
          all_good = requests.all? { |request| request.documented? }
          res += "file: #{key} #{all_good ? '✔' : '✖'}\n"
        end
        res += "\n2. Find response status code:\n"
        @realized_unit.test_file_paths.each do |key, requests|
          all_good = requests.all? { |request| request.response_documented? }
          res += "file: #{key} #{all_good ? '✔' : '✖'}\n"
        end
        res += "\n3. Find response json-schemas:\n"
        @realized_unit.test_file_paths.each do |key, requests|
          all_good = requests.all? { |request| request.response_json_schemas? }
          res += "file: #{key} #{all_good ? '✔' : '✖'}\n"
        end
        res += "\n4. Check valid json-schemas:\n"
        @realized_unit.test_file_paths.each do |key, requests|
          all_good = requests.all? { |request| request.valid_json_schemas? }
          res += "file: #{key} #{all_good ? '✔' : '✖'}\n"
        end
        res
      end
    end
  end
end
