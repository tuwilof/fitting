require 'fitting/records/documented'
require 'fitting/records/tested'

module Fitting
  class Records
    def initialize(tomogram)
      @documented = Fitting::Records::Documented.new(tomogram)
      @tested = Fitting::Records::Tested.new
    end

    def add(env_response, env_request)
      @tested.add(env_response, env_request)
    end

    def save_statistics; end
  end
end
