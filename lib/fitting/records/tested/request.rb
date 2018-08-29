require 'tomograph/path'
require 'fitting/records/tested/response'
require 'fitting/records/spherical/request'

module Fitting
  class Records
    class Tested
      class Request
        def initialize(env_response, test_title)
          @env_response = env_response
          @test_title = test_title
        end

        def method
          @method ||= @env_response.request.request_method
        end

        def path
          @path ||= Tomograph::Path.new(@env_response.request.env['PATH_INFO'] || @env_response.request.fullpath)
        end

        def body
          @body ||= @env_response.request.env['action_dispatch.request.request_parameters']
        end

        def response
          @response ||= Fitting::Records::Tested::Response.new(@env_response)
        end

        def test_path
          @test_path ||= @test_title[/#{'\(\.'}(.*?)#{'\)'}/m, 1] || @test_title[/#{'\.'}(.*?)#{'\"'}/m, 1]
        end

        def test_file_path
          @test_file_path ||= test_path.split(':').first
        end

        def to_spherical
          Fitting::Records::Spherical::Request.new(
            method: method,
            path: path,
            body: body,
            response: response.to_spherical,
            title: test_path,
            group: test_file_path
          )
        end
      end
    end
  end
end
