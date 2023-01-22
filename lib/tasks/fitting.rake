require 'fitting/log'
require 'fitting/doc'
require 'fitting/skip'
require 'fitting/nocov'
require 'fitting/rep'

namespace :fitting do
  task :report do
    logs = Fitting::Log.all(File.read('log/test.log'),  YAML.safe_load(File.read('.fitting.yml'))['LogFormat'])
    docs = Fitting::Doc.all(YAML.safe_load(File.read('.fitting.yml')))
    skips = Fitting::Skip.all(YAML.safe_load(File.read('.fitting.yml')))

    logs.each do |log|
      Fitting::Doc.cover!(docs, log)
      log.access!
    rescue Fitting::Doc::NotFound => e
      next log.pending! if Fitting::Skip.find(skips, log)
      log.failure!(e)
    end
    Fitting::Log.report(logs)

    Fitting::NoCov.all(YAML.safe_load(File.read('.fitting.yml'))).each do |nocov|
      nocov.find(docs).nocover!
    end
    Fitting::Rep.new(docs).save!
    Fitting::Doc.report(docs)
  end
end
