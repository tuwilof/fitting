namespace :fitting do
  desc 'Fitting documentation'
  task :documentation do
    puts `bundle exec rspec ./spec/controllers`
    puts `cat fitting/stats`
  end
end
