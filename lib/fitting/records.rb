require 'fitting/records/documented'
require 'fitting/records/tested'

module Fitting
  class Records
    def initialize
      @tested = Fitting::Records::Tested.new
    end

    def add(env_response)
      @tested.add(env_response)
    end

    def initialization_of_documentation(tomogram)
      @documented = Fitting::Records::Documented.new(tomogram)
    end

    def save_statistics
      @documented.join(@tested)
    end
  end
end
