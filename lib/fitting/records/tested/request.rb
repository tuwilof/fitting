require 'tomograph/path'
require 'fitting/records/tested/response'
require 'fitting/records/spherical/request'

module Fitting
  class Records
    class Tested
      class Request
        def initialize(response, example)
          @example = example
          @response = response
        end

        def host
          @host ||= @response.request.host
        end

        def method
          @method ||= @response.request.request_method
        end

        def path
          @path ||= Tomograph::Path.new(@response.request.fullpath)
        end

        def body
          @body ||= @response.request.request_parameters
        end

        def fitting_response
          @fitting_response ||= Fitting::Records::Tested::Response.new(@response)
        end

        def test_path
          @test_path ||= @example.location
        end

        def test_file_path
          @test_file_path ||= @example.file_path
        end

        def to_spherical
          Fitting::Records::Spherical::Request.new(
            method: method,
            path: path,
            body: body,
            response: fitting_response.to_spherical,
            title: test_path,
            group: test_file_path,
            host: host
          )
        end
      end
    end
  end
end
