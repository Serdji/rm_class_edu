def resque_process(queue  = '*', resque_numbers)
  # @@resque_number ||= 0
  # @@resque_number += 1

  resque_numbers.each do |resque_number|
    name = queue.to_s.gsub(/\W/, '-')[0..30]
    process_title = "resque.#{resque_number}.#{name}"
    process(process_title) do
      env('QUEUE' => queue, 'JOBS_PER_FORK' => 1_000_000)

      pid_file "#{PID_PATH}/#{process_title}.pid"

      daemonize true
      start_command 'bundle exec rake environment resque:work'
      stop_signals [:USR1, 0, :TERM, 10.seconds, :KILL]

      stdout "#{LOG_PATH}/resque.#{name}.stdout.log"
      stderr "#{LOG_PATH}/resque.#{name}.stderr.log"

      monitor_children do
        stop_command 'kill {PID}'
      end
    end
  end
end
