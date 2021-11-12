require 'terminal-table'

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
        tables = []

        @prefixes_details.each do |prefix_details|
          title = prefix_details[:name]
          @tests_without_actions += prefix_details[:actions][:tests_without_actions] # непонятно что такое

          tables << Terminal::Table.new do |t|
            t.title = title
            t.headings = %w[method path cover]

            prefix_details[:actions][:actions_details].each do |action|
              @tests_without_responses += action[:responses][:tests_without_responses]

              path_details = action[:responses][:responses_details].map do |responses_detail|
                @good = false if responses_detail[:combinations][:cover_percent] != '100%'
                [responses_detail[:combinations][:cover_percent], responses_detail[:method]]
              end.join(' ')

              t.add_row [action[:method], action[:path], path_details]
            end
          end
        end

        tables
      end

      def output_sum
        doc_res = ''
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
