module Fitting
  module Storage
    module Responses
      class << self
        def push(test)
          @responses ||= []
          @responses.push(test)
        end

        def all
          @responses ||= []
          @responses.uniq
        end

        def routes
          all.map do |response|
            response.route if response.documented? && response.valid?
          end.compact.uniq
        end
      end
    end
  end
end
