module Fitting
  class Rep
    class JSON
      def self.to_s(actions)
        ::JSON.pretty_generate(
          actions.inject({}) do |sum, action|
            sum.merge({
                        action.key => [
                          nil,
                          action.host_cover,
                          action.prefix_cover,
                          action.path_cover,
                          action.method_cover,
                          0
                        ]
                      })
          end
        )
      end

      def self.lock(actions)
        ::JSON.pretty_generate(
          actions.inject({}) do |sum, action|
            sum.merge({
                        action.key => action.to_yaml.split("\n")
                      })
          end
        )
      end
    end
  end
end
