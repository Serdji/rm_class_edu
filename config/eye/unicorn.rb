def unicorn_process(proxy, name, _config)
  proxy.process name do
    pid_file "#{PID_PATH}/unicorn.pid"
    stdall "#{LOG_PATH}/unicorn.log"

    stop_signals [:QUIT, 15.seconds, :TERM]

    start_command "bundle exec unicorn -Dc #{ROOT_PATH}/config/unicorn.rb -E #{RAILS_ENV}"
    restart_command "kill -USR2 {PID}"

    check :cpu, every: 30, times: 3, below: 95
    check :memory, every: 30, times: [3, 5], below: 300.megabytes

    monitor_children do
      stop_command 'kill -QUIT {PID}'
      check :cpu, every: 30, times: 3, below: 95
      check :memory, every: 30, times: [3, 5], below: 300.megabytes
    end
  end
end
