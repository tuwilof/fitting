require 'tomograph'

module Fitting
  module Storage
    class WhiteList
      def initialize(white_list, resource_white_list, resources)
        @white_list = white_list
        @resource_white_list = resource_white_list
        @resources = resources
      end

      def to_a
        return @white_list if @white_list
        @white_list = transformation
      end

      def without_group
        @resource_white_list.inject([]) do |all_requests, asd|
          if asd[1] == []
            requests(@resources[asd[0]], all_requests)
          else
            requests(asd[1], all_requests)
          end
        end.flatten.uniq
      end

      def requests(resource, all_requests)
        return all_requests unless resource

        resource.map do |request|
          all_requests.push(request_hash(request))
        end
        all_requests
      end

      def transformation
        result = without_group.group_by { |action| action[:path] }
        result.inject({}) do |res, group|
          methods = group.last.map { |gr| gr[:method] }
          res.merge(group.first => methods)
        end
      end

      def request_hash(request)
        array = request.split(' ')
        {
          method: array[0],
          path: Tomograph::Path.new(array[1]).to_s
        }
      end
    end
  end
end
