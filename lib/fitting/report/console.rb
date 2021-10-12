module Fitting
  module Report
    class Console
      def initialize(tests_without_prefixes, prefixes_details)
        @tests_without_prefixes = tests_without_prefixes
        @prefixes_details = prefixes_details
        @good = true
        @tests_without_actions = []
        @tests_without_responses = []
      end

      def output
        doc_res = @prefixes_details.inject('') do |res, prefix_details|
          res += "#{prefix_details[:name]}\n"
          @tests_without_actions += prefix_details[:actions][:tests_without_actions]
          res += prefix_details[:actions][:actions_details].inject('') do |res_actions, action|
            res_actions += "#{action[:method]}\t#{action[:path]}"
            tab = "\t" * (8 - action[:path].size / 8)
            @tests_without_responses += action[:responses][:tests_without_responses]
            res_actions += tab + action[:responses][:responses_details].inject('') do |res_responses, response|
              @good = false if response[:combinations][:cover_percent] != '100%'
              res_responses += " #{response[:combinations][:cover_percent]} #{response[:method]}"
            end
            res_actions += "\n"
          end
        end
        doc_res += "\n"
        doc_res += "tests_without_prefixes: #{@tests_without_prefixes.size}\n"
        doc_res += "tests_without_actions: #{@tests_without_actions.size}\n"
        doc_res += "tests_without_responses: #{@tests_without_responses.size}\n"
      end

      def good?
        return false if @tests_without_prefixes.size != 0
        return false if @tests_without_actions.size != 0
        return false if @tests_without_responses.size != 0

        @good
      end
    end
  end
end
