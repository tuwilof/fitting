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
          all_good = requests.all?(&:documented?)
          res += "file: #{key} #{all_good ? '✔' : '✖'}\n"
        end
        res += "\n2. Find response status code:\n"
        @realized_unit.test_file_paths.each do |key, requests|
          all_good = requests.all?(&:response_documented?)
          res += "file: #{key} #{all_good ? '✔' : '✖'}\n"
        end
        res += "\n3. Find response json-schemas:\n"
        @realized_unit.test_file_paths.each do |key, requests|
          all_good = requests.all?(&:response_json_schemas?)
          res += "file: #{key} #{all_good ? '✔' : '✖'}\n"
        end
        res += "\n4. Check valid json-schemas:\n"
        @realized_unit.test_file_paths.each do |key, requests|
          all_good = requests.all?(&:valid_json_schemas?)
          res += "path: #{key} #{all_good ? '✔' : '✖'}\n"
          next if all_good
          requests.map do |request|
            next if request.valid_json_schemas?
            res += "  full path: #{request.test_path} ✖\n"
            res += "    request.method #{request.method}\n"
            res += "    request.path #{request.path}\n"
            res += "    request.response.status #{request.response.status}\n"
            res += "    request.response.body #{request.response.body}\n\n"
            request.invalid_json_schemas.map do |schema|
              res += "    json_schemas: #{schema[:json_schema]}\n"
              res += "    fully_validate: #{schema[:fully_validate]}\n\n"
            end
          end
        end
        res
      end
    end
  end
end
