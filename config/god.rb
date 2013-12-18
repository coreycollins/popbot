rails_env   = ENV['RAILS_ENV']  || "development"
rails_root  = File.expand_path(File.join(File.dirname(__FILE__),'..'))

God.watch do |w|
  w.dir      = "#{rails_root}"
  w.name     = "resque"
  w.interval = 30.seconds
  w.env      = {"RAILS_ENV"=>rails_env, "QUEUE"=>"*"}
  w.start    = "bundle exec rake -f #{rails_root}/Rakefile resque:work"
  w.log      = "#{rails_root}/log/resque.log"
  w.err_log  = "#{rails_root}/log/resque.log"
  w.pid_file = "#{rails_root}/tmp/pids/resque.pid"
  w.behavior(:clean_pid_file)

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end
 
  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end
 
    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end
 
  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end


end


God.watch do |w|
  w.dir      = "#{rails_root}"
  w.name     = "resque_scheduler"
  w.interval = 30.seconds
  w.env      = {"RAILS_ENV"=>rails_env}
  w.start    = "bundle exec rake -f #{rails_root}/Rakefile resque:scheduler"
  w.log      = "#{rails_root}/log/resque_scheduler.log"
  w.err_log  = "#{rails_root}/log/resque_scheduler_error.log"
  w.pid_file = "#{rails_root}/tmp/pids/resque-scheduler.pid"
  w.behavior(:clean_pid_file)

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end
 
  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end
 
    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end
 
  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end

end
