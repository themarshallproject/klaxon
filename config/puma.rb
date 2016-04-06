environment ENV['RACK_ENV'] || 'development'

workers Integer(ENV['PUMA_WORKERS'] || 4)
threads Integer(ENV['MIN_THREADS']  || 4), Integer(ENV['MAX_THREADS'] || 4)

preload_app!

on_worker_boot do
  ActiveRecord::Base.connection_pool.disconnect!
  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[Rails.env] || Rails.application.config.database_configuration[Rails.env]
    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
    config['pool']              = (ENV['DB_POOL'] || 5).to_i
    ActiveRecord::Base.establish_connection
  end
end

port = Integer(ENV['PORT'] || 3000)

bind "tcp://0.0.0.0:#{port}"
