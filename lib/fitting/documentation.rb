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
          black?(response)
        end
      else
        []
      end
    end

    def white
      if @white_list
        all.select do |response|
          white?(response)
        end
      else
        all
      end
    end

    def all
      @all ||= @tomogram.to_hash.each_with_object([]) do |request, routes|
        responses(request).map do |status, indexes|
          indexes.times do |index|
            route = "#{request['method']}\t#{request['path']} #{status} #{index}"
            routes.push(route)
          end
        end
      end.uniq
    end

    def responses(request)
      request['responses'].each_with_object({}) do |response, responses|
        responses[response['status']] ||= 0
        responses[response['status']] += 1
      end
    end

    def black?(response)
      data = response.split(' ')
      data[1] && !@white_list[data[1]] || (@white_list[data[1]] != [] && !@white_list[data[1]].include?(data[0]))
    end

    def white?(response)
      data = response.split(' ')
      data[1] && @white_list[data[1]] && (@white_list[data[1]] == [] || @white_list[data[1]].include?(data[0]))
    end
  end
end
