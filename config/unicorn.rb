root = '/var/www/class.rambler.ru' # File.expand_path('../../../..', __FILE__)

current = "#{root}/current"
shared = "#{root}/shared"

working_directory current

pid "#{shared}/tmp/pids/unicorn.pid"

stderr_path "#{shared}/log/unicorn.stderr.log"
stdout_path "#{shared}/log/unicorn.stdout.log"

listen 8088, reuseport: true

worker_processes %w(production).include?(ENV['RACK_ENV']) ? 16 : 2

timeout 30

preload_app true

before_exec do |_server|
  ENV['BUNDLE_GEMFILE'] = "#{current}/Gemfile"
end

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"

  if File.exists?(old_pid) && old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      pid = File.read(old_pid).to_i
      Process.kill(sig, pid)
    rescue Errno::ENOENT, Errno::ESRCH => e
      $stderr.puts "#{e.class}: #{e.message} with old master pid #{pid}"
    end
  end

  ActiveRecord::Base.connection.disconnect! if defined? ActiveRecord::Base

  Redis.current.disconnect! if defined? Redis
end

after_fork do |_server, _worker|
  ActiveRecord::Base.establish_connection if defined? ActiveRecord::Base

  if defined? Redis
    Redis.current = RedisFactory.build_connection_for(:cache)
  end
end
