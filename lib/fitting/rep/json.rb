module Fitting
  class Rep
    class JSON
      def self.to_s(actions)
        actions.sort { |a, b| a.cover <=> b.cover }.inject({}) do |sum, action|
          sum.merge({
                      action.key => action.to_lock
                    })
        end
      end

      def self.lock(actions)
        actions.inject({}) do |sum, action|
          sum.merge({
                      action.key => action.to_yaml
                    })
        end
      end
    end
  end
end
