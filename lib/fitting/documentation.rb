require 'multi_json'

module Fitting
  class Documentation
    def initialize(tomogram, white_list)
      @tomogram = tomogram
      @white_list = white_list
    end

    def black
      if @white_list
        all.select do |response|
          data = response.split(' ')
          data[1] && !@white_list[data[1]] || (@white_list[data[1]] != [] && !@white_list[data[1]].include?(data[0]))
        end
      else
        []
      end
    end

    def white
      if @white_list
        all.select do |response|
          data = response.split(' ')
          data[1] && @white_list[data[1]] && (@white_list[data[1]] == [] || @white_list[data[1]].include?(data[0]))
        end
      else
        all
      end
    end

    def all
      @all ||= @tomogram.inject([]) do |routes, request|
        request['responses'].inject({}) do |responses, response|
          responses[response['status']] ||= 0
          responses[response['status']] += 1
          responses
        end.map do |status, indexes|
          indexes.times do |index|
            route = "#{request['method']}\t#{request['path']} #{status} #{index}"
            routes.push(route)
          end
        end
        routes
      end.uniq
    end
  end
end
