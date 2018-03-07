require 'json'

module Fitting
  class Records
    class Spherical
      class Response
        attr_reader :status, :body

        def initialize(status:, body:)
          @status = status
          @body = body
        end

        def dump
          JSON.dump({
            status: status,
            body: body
          })
        end

        class << self
          def load(json)
            hash = JSON.load(json)
            new(status: hash["status"], body: hash["body"])
          end
        end
      end
    end
  end
end
