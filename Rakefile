begin
  require 'bundler'
  require "bundler/gem_tasks"
rescue
end

require 'rake/testtask'
desc "Run Domodoro tests"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :default => :test
