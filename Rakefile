require "bundler/gem_tasks"

require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = true
end

require "rubocop/rake_task"
RuboCop::RakeTask.new(:style)

task default: %i[test style]
