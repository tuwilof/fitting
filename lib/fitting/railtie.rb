require 'rake'

module Fitting
  class MyRailtie < Rails::Railtie
    rake_tasks do
      load 'tasks/fitting.rake'
      load 'tasks/fitting_outgoing.rake'
    end
  end
end
