if Rails.env.production?
  $redis = Redis.connect(url: ENV["REDISTOGO_URL"])
end
