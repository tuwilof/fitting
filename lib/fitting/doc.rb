require 'fitting/doc/action'
require 'tomograph'

module Fitting
  class Doc
    class NotFound < RuntimeError; end

    def self.all
      apis = YAML.safe_load(File.read('.fitting.yml'))['APIs']
      return [] unless apis
      apis.map do |api|
        if api['type'] == 'openapi2'
          Tomograph::Tomogram.new(prefix: api['prefix'] || '', openapi2_json_path: api['path']).to_a.map do |action|
            Fitting::Doc::Action.new(
              api['host'],
              api['prefix'] || '',
              action.to_hash['method'],
              action.to_hash['path'].path,
              action.responses
            )
          end
        elsif api['type'] == 'openapi3'
          Tomograph::Tomogram.new(prefix: api['prefix'] || '', openapi3_yaml_path: api['path']).to_a.map do |action|
            Fitting::Doc::Action.new(
              api['host'],
              api['prefix'] || '',
              action.to_hash['method'],
              action.to_hash['path'].path,
              action.responses
            )
          end
        elsif api['type'] == 'drafter'
          Tomograph::Tomogram.new(prefix: api['prefix'] || '', drafter_yaml_path: api['path']).to_a.map do |action|
            Fitting::Doc::Action.new(
              api['host'],
              api['prefix'] || '',
              action.to_hash['method'],
              action.to_hash['path'].path,
              action.responses
            )
          end
        elsif api['type'] == 'crafter'
          Tomograph::Tomogram.new(prefix: api['prefix'] || '', crafter_yaml_path: api['path']).to_a.map do |action|
            Fitting::Doc::Action.new(
              api['host'],
              api['prefix'] || '',
              action.to_hash['method'],
              action.to_hash['path'].path,
              action.responses
            )
          end
        elsif api['type'] == 'tomogram'
          Tomograph::Tomogram.new(prefix: api['prefix'] || '', tomogram_json_path: api['path']).to_a.map do |action|
            Fitting::Doc::Action.new(
              api['host'],
              api['prefix'] || '',
              action.to_hash['method'],
              action.to_hash['path'].path,
              action.responses
            )
          end
        end
      end.flatten
    end

    def self.cover!(docs, log)
      docs.each do |doc|
        return if doc.cover!(log)
      end
      raise NotFound.new "log: #{log.method} #{log.host} #{log.url} #{log.status}"
    rescue Fitting::Doc::Action::NotFound => e
      raise NotFound.new "log error: #{e.message}"
    end

    def self.debug(docs, debug)
      docs.each do |doc|
        res = doc.debug(debug)
        return res if res
      end
      raise NotFound
    end

    def self.report(actions)
      all = 0
      cov = 0
      actions.each do |action|
        action.to_hash.values.first.each do |cover_line|
          if cover_line == nil
            next
          elsif cover_line == 0
            all += 1
          elsif cover_line > 0
            all += 1
            cov += 1
          end
        end
      end
      res = (cov.to_f / all.to_f * 100).round(2)
      puts "Coverage: #{res}%"
      if res == 100.00
        exit 0
      else
        exit 1
      end
    end
  end
end
