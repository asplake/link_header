require "bundler/gem_tasks"
require "rake/testtask"

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/test_*.rb']
end
