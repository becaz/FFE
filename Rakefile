require 'rake/testtask'

task default: 'test'

Rake::TestTask.new do |task|
  task.libs << "test"
  task.pattern = 'test/**/test_*.rb'
end
