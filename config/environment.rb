# Load the Rails application.
require_relative "application"

Rails.application.configure do
  cache_servers = %w(redis://cache-01:6379/0 redis://cache-02:6379/0)
  config.cache_store = :redis_cache_store, { url: cache_servers,
    namespace: 'podcasts',
    connect_timeout:    30,  # Defaults to 20 seconds
    read_timeout:       0.2, # Defaults to 1 second
    write_timeout:      0.2, # Defaults to 1 second
    reconnect_attempts: 1,   # Defaults to 0
  
    error_handler: -> (method:, returning:, exception:) {
      # Report errors to Sentry as warnings
      Raven.capture_exception exception, level: 'warning',
        tags: { method: method, returning: returning }
    }
  }
  
end

# Initialize the Rails application.
Rails.application.initialize!
