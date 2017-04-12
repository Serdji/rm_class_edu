require 'resque/tasks'
task 'resque:setup' => :environment

require_relative 'config/application'

Rails.application.load_tasks

seed_tasks = Rake.application.tasks.select { |task| task.name =~ /db:seed:/ }
seed_tasks.unshift :environment if Rake::Task.task_defined?(:environment)

Rake::Task['db:seed'].enhance seed_tasks

namespace :resque do
  task :setup do
    Resque.before_fork = proc do
      ActiveRecord::Base.connection.disconnect!
    end

    Resque.after_fork = proc do
      ActiveRecord::Base.establish_connection
    end
  end
end
