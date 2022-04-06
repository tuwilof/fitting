require 'json'
require 'fitting/records/spherical/response'

module Fitting
  class Records
    class Spherical
      class Request
        attr_reader :method, :path, :body, :response, :title, :group, :host

        def initialize(method:, path:, body:, response:, title:, group:, host:)
          @method = method
          @path = path
          @body = body
          @response = response
          @title = title
          @group = group
          @host = host
        end

        def to_hash
          {
            method: method,
            path: path.to_s,
            body: body,
            response: response.to_hash,
            title: title,
            group: group,
            host: host
          }
        end

        def to_json(*_args)
          JSON.dump(to_hash)
        end

        class << self
          def load(hash)
            new(
              method: hash['method'],
              path: hash['path'],
              body: hash['body'],
              response: Fitting::Records::Spherical::Response.load(hash['response']),
              title: hash['title'],
              group: hash['group'],
              host: hash['host']
            )
          end
        end
      end
    end
  end
end
