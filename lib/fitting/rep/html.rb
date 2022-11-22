module Fitting
  class Rep
    class HTML
      def self.copy_file(folder, name)
        File.open("#{folder}/#{name}", 'w') do |file|
          file.write(
            File.read("#{$LOAD_PATH.find { |i| i.include?('fitting') }}/templates/htmlcss/#{name}")
          )
        end
      end

      def self.copy_file_with_json(folder, name, fitting_json, fitting_lock_json)
        res = File.read("#{$LOAD_PATH.find { |i| i.include?('fitting') }}/templates/htmlcss/#{name}")
        File.open("#{folder}/#{name}", 'w') do |file|
          file.write(
            res
              .gsub("{'fitting json': []}", ::JSON.pretty_generate(fitting_json))
              .gsub("{'fitting lock json': []}", ::JSON.pretty_generate(fitting_lock_json))
          )
        end
      end

      def self.bootstrap(folder, fitting_json, fitting_lock_json)
        copy_file_with_json(folder, 'fitting.html', fitting_json, fitting_lock_json)
        copy_file(folder, 'bootstrap-nightshade.min.css')
        copy_file(folder, 'darkmode.min.js')
        copy_file(folder, 'jquery-3.6.0.min.js')
        copy_file(folder, 'bootstrap.min.js')
      end
    end
  end
end
