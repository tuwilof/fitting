require 'fitting/records/spherical/request'
require 'json'

module Fitting
  class Records
    class Spherical
      class Requests
        def to_a
          return @to_a if @to_a

          array = []
          Dir['fitting_tests/*.json'].each do |file|
            array += JSON.load(File.read(file))
          end
          @to_a = array.inject([]) do |res, tested_request|
            res.push(Fitting::Records::Spherical::Request.load(tested_request))
          end
        end
      end
    end
  end
end
