require 'rake'

module Fitting
  class MyRailtie < Rails::Railtie
    rake_tasks do
      load 'tasks/fitting.rake'
    end
  end
end
