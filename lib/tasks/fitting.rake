require 'fitting/log'
require 'fitting/doc'
require 'fitting/rep'

namespace :fitting do
  task :report do
    logs = Fitting::Log.all
    docs = Fitting::Doc.all(YAML.safe_load(File.read('.fitting.yml')))

    logs.each do |log|
      Fitting::Doc.find!(docs, log).cover!
    rescue Fitting::Doc::Skip
      log.pending!
    rescue Fitting::Doc::NotFound => e
      log.failure!(e)
    end

    Fitting::Log.report(logs)
    Fitting::Rep.new(docs).save!
  end
end
