require 'fitting/rep/html'

module Fitting
  class Rep
    def initialize(apis)
      @actions = apis[:provided] + apis[:used]
    end

    def save!
      destination = 'coverage'
      FileUtils.mkdir_p(destination)

      fitting_json = @actions.inject({}) do |sum, action|
        sum.merge(action.to_hash)
      end
      fitting_lock_json = @actions.inject({}) do |sum, action|
        sum.merge(action.to_hash_lock)
      end
      File.open('coverage/.fitting.json', 'w') { |file| file.write(::JSON.pretty_generate(fitting_json)) }
      File.open('coverage/.fitting.lock.json', 'w') { |file| file.write(::JSON.pretty_generate(fitting_lock_json)) }
      Fitting::Rep::HTML.bootstrap('coverage', fitting_json, fitting_lock_json)
    end
  end
end
