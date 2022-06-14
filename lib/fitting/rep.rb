require 'fitting/rep/json'
require 'fitting/rep/html'

module Fitting
  class Rep
    def initialize(apis)
      @actions = apis[:provided] + apis[:used]
    end

    def save!
      destination = 'coverage'
      FileUtils.mkdir_p(destination)

      File.open('coverage/fitting.json', 'w') { |file| file.write(Fitting::Rep::JSON.to_s(@actions)) }
      File.open('coverage/fitting.lock.json', 'w') { |file| file.write(Fitting::Rep::JSON.lock(@actions)) }
      File.open('coverage/fitting.html', 'w') { |file| file.write(Fitting::Rep::HTML.to_s(@actions)) }
    end
  end
end
