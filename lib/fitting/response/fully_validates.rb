module Fitting
  class Response
    class FullyValidates < Array
      def self.craft(fully_validates)
        new(fully_validates)
      end

      def valid?
        any? { |fully_validate| fully_validate == [] }
      end

      def to_s
        inject("") do |res, fully_validate|
          res + "#{fully_validate.join("\n")}\n\n"
        end
      end
    end
  end
end
