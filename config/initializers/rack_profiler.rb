if Rails.env == 'development' && ENV['PROFILE']
  require 'rack-mini-profiler'
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
