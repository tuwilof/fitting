require 'fitting/cover/response'
require 'haml'
require 'json'

module Fitting
  class Cover
    def initialize(all_responses, coverage)
      @all_responses = all_responses
      @coverage = coverage
      @list = {}
    end

    def to_hash
      return @list unless @list == {}
      @all_responses.each_with_object({}) do |response, res|
        next res unless response.documented?
        if res.key?(response.route)
          res[response.route].update(response)
        else
          res[response.route] = Fitting::Cover::Response.new(response)
        end
      end.map do |key, value|
        @list[key] = value.to_hash
      end
      @list
    end

    def template
      return @template if @template
      @template = {}
      to_hash.each do |key, value|
        @template[key] = value
        @template[key]['type'] = 'passed'
        @template[key]['json_schema'] = JSON.pretty_generate(value['json_schemas'].last)
      end
      @template
    end

    def save
      to_hash
      contents = File.read(File.expand_path('../view/report.html.haml', __FILE__))
      html = "<style>\n#{File.read(File.expand_path('../view/style.css', __FILE__))}\n</style>\n"
      html += Haml::Engine.new(contents).render(
        Object.new,
        :@to_hash => template
      )
      html
    end
  end
end
