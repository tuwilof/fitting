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

      fitting_json = Fitting::Rep::JSON.to_s(@actions)
      fitting_lock_json = Fitting::Rep::JSON.lock(@actions)
      File.open('coverage/fitting.json', 'w') { |file| file.write(::JSON.pretty_generate(fitting_json)) }
      File.open('coverage/fitting.lock.json', 'w') { |file| file.write(::JSON.pretty_generate(fitting_lock_json)) }
      File.open('coverage/fitting.html', 'w') { |file| file.write(Fitting::Rep::HTML.to_str(fitting_json, fitting_lock_json)) }
      Fitting::Rep::HTML.bootstrap('coverage', fitting_json, fitting_lock_json)
    end
  end
end
