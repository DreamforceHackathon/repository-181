if Rails.env.production?
  $redis = Redis.connect(url: ENV["REDISTOGO_URL"])
  Sidekiq.configure_client { |config| config.redis = $redis }
  Sidekiq.configure_server { |config| config.redis = $redis }
end
