require 'tomograph'

module Fitting
  module Storage
    class WhiteList
      def initialize(prefix, white_list, resource_white_list, include_resources, include_actions, resources)
        @prefix = prefix
        @white_list = white_list
        @resource_white_list = resource_white_list
        @include_resources = include_resources
        @include_actions = include_actions
        @resources = resources
        @warnings = []
      end

      def to_a
        return nil if @white_list == nil && @resource_white_list == nil && @include_resources == nil && @include_actions == nil
        return @white_list if @white_list
        return @white_list = transformation if @resource_white_list
        @white_list = {}
        @white_list.merge!(new_transformation) if @include_resources
        @white_list.merge!(postnew_transformation) if @include_actions
        @white_list
      end

      def without_group
        return @without_group_list if @without_group_list
        @without_group_list = @resource_white_list.inject([]) do |all_requests, resource|
          resource_selection(resource, all_requests)
        end.flatten.uniq
        puts_warnings
        @without_group_list
      end

      def resource_selection(resource, all_requests)
        if resource[1] == []
          find_warnings(resource[0])
          requests(@resources[resource[0]], all_requests)
        else
          requests(resource[1], all_requests)
        end
      end

      def find_warnings(resource)
        return nil if @resources[resource]
        @warnings.push(
          "FITTING WARNING: In the documentation there isn't resource from the resource_white_list #{resource}"
        )
      end

      def puts_warnings
        return nil if @warnings == []
        warnings_string = @warnings.join("\n")
        puts "\n#{warnings_string}"
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

      def new_transformation
        @new_resources = {}
        @resources.map do |key, value|
          @new_resources.merge!(Tomograph::Path.new(key).to_s => value)
        end
        result = new_without_group.group_by { |action| action[:path] }
        result.inject({}) do |res, group|
          methods = group.last.map { |gr| gr[:method] }
          res.merge(group.first => methods)
        end
      end

      def new_without_group
        return @newwithout_group_list if @newwithout_group_list
        @newwithout_group_list = @include_resources.inject([]) do |all_requests, resource|
          if resource[0] == '/'
            new_resource_selection(resource, all_requests)
          else
            new_resource_selection("/#{resource}", all_requests)
          end
        end.flatten.uniq
        puts_warnings
        @newwithout_group_list
      end

      def new_resource_selection(resource, all_requests)
        new_find_warnings(resource)
        new_requests(@new_resources[resource], all_requests)
      end

      def new_requests(resource, all_requests)
        return all_requests unless resource

        resource.map do |request|
          all_requests.push(request_hash(request))
        end
        all_requests
      end

      def new_find_warnings(resource)
        return nil if @new_resources[resource]
        @warnings.push(
          "FITTING WARNING: In the documentation there isn't resource from the resource_white_list #{resource}"
        )
      end

      def postnew_transformation
        result = postnew_without_group.group_by { |action| action[:path] }
        result.inject({}) do |res, group|
          methods = group.last.map { |gr| gr[:method] }
          res.merge(group.first => methods)
        end
      end

      def postnew_without_group
        return @postnewwithout_group_list if @postnewwithout_group_list
        @postnewwithout_group_list = @include_actions.inject([]) do |all_requests, resource|
          method, path = resource.split(' ')
          if path[0] == '/'
            new_requests(["#{method} #{@prefix}#{path}"], all_requests)
          else
            new_requests(["#{method} #{@prefix}/#{path}"], all_requests)
          end
        end.flatten.uniq
        puts_warnings
        @postnewwithout_group_list
      end
    end
  end
end
