require File.join(Rails.root,'app/jobs/send_message')
require 'resque_scheduler'

Resque.redis = Redis.new