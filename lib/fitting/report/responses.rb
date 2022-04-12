require 'fitting/report/response'

module Fitting
  module Report
    class Responses
      class NotFound < RuntimeError
        attr_reader :log
        def initialize(msg, log)
          @log = log
          super(msg)
        end
      end

      def initialize(responses)
        @responses = responses
        @responses = []
        responses.to_a.map do |response|
          @responses.push(Fitting::Report::Response.new(response))
        end
      end

      def find!(log)
        @responses.map do |response|
          if response.status.to_s == log.status && JSON::Validator.fully_validate(response.body, log.body) == []
            return response
          end
        end

        raise NotFound.new("method: #{log.method}, host: #{log.host}, path: #{log.path}, status: #{log.status}, body: #{log.body}", log)
      end

      def to_a
        @responses
      end
    end
  end
end
