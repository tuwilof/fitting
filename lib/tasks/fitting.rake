require 'fitting/log'
require 'fitting/action'
require 'fitting/rept'

namespace :fitting do
  task :report do
    logs = Fitting::Log.all
    actions = Fitting::Action.all

    logs.each do |log|
      Fitting::Action.find!(actions, log).cover!(log)
    rescue Fitting::Action::Skip
      log.pending!
    rescue Fitting::Action::NotFound => error
      log.failure!(error)
    end

    Fitting::Log.report(logs)
    Fitting::Rept.new(actions).save!
  end
end
