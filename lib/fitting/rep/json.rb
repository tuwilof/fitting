module Fitting
  class Rep
    class JSON
      def self.to_s(actions)
        actions.sort { |a, b| a.cover <=> b.cover }.inject({}) do |sum, action|
          res = []
          (action.to_yaml.split("\n").size).times { res.push(nil) }
          res[1] = action.host_cover
          res[2] = action.prefix_cover
          res[3] = action.path_cover
          res[4] = action.method_cover

          sum.merge({
                      action.key => res
                    })
        end
      end

      def self.lock(actions)
        actions.inject({}) do |sum, action|
          sum.merge({
                      action.key => action.to_yaml.split("\n")
                    })
        end
      end
    end
  end
end
