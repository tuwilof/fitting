require 'fitting/records/documented'
require 'fitting/records/tested'
require 'fitting/storage/documentation'
require 'fitting/storage/white_list'

module Fitting
  class Records
    def initialize
      @tested = Fitting::Records::Tested.new
    end

    def add(env_response)
      @tested.add(env_response)
    end

    def initialization_of_documentation
      @documented = Fitting::Records::Documented.new(
        Fitting::Storage::Documentation.tomogram.to_hash
      )
      @documented.joind_white_list(white_list)
    end

    def save_statistics
      @documented.join(@tested)
    end

    def white_list
      Fitting::Storage::WhiteList.new(
        Fitting.configuration.white_list,
        Fitting.configuration.resource_white_list,
        Fitting::Storage::Documentation.tomogram.to_resources
      ).to_a
    end
  end
end
