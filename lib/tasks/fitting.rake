namespace :fitting do
  desc 'Fitting documentation'
  task :documentation do
    puts `bundle exec rspec ./spec/controllers`
    puts `cat fitting/stats`

    result = File.read('fitting/not_covered')
    unless result == "\n"
      puts 'Not all responses from the whitelist are covered!'
      exit 1
    end
  end
end
