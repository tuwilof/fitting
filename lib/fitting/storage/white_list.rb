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

      def transformation
        res = @resource_white_list.inject([]) do |res, asd|
          if asd[1] == []
            @resources[asd[0]].map do |vbn|
              qwe = vbn.split(' ')
              res.push({
                method: qwe[0],
                path: qwe[1].split('/{?').first.split('{?').first
              })
            end
            res
          else
            asd[1].map do |request|
              qwe = request.split(' ')
              res.push({
                method: qwe[0],
                path: qwe[1].split('/{?').first.split('{?').first
              })
            end
            res
          end
        end.flatten.uniq

        res = res.group_by {|action| action[:path]}
        res.inject({}) do |res, group|
          methods = group.last.map {|gr| gr[:method]}
          res.merge(group.first => methods)
        end
      end
    end
  end
end
