module Fitting
  module Report
    class Console
      def initialize(tests_without_prefixes, prefixes_details)
        @tests_without_prefixes = tests_without_prefixes
        @prefixes_details = prefixes_details
        @good = true
      end

      def output
        @prefixes_details.inject('') do |res, prefix_details|
          res += "#{prefix_details[:name]}\n"
          res += prefix_details[:actions][:actions_details].inject('') do |res_actions, action|
            res_actions += "#{action[:method]}\t#{action[:path]}"
            tab = "\t" * ((3 - action[:path].size / 8) + 3)
            res_actions += tab + action[:responses][:responses_details].inject('') do |res_responses, response|
              @good = false if response[:combinations][:cover_percent] != '100%'
              res_responses += " #{response[:combinations][:cover_percent]} #{response[:method]}"
            end
            res_actions += "\n"
          end
        end
      end

      def good?
        @good
      end
    end
  end
end
