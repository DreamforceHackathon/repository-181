if Rails.env.production?g
  $redis = Redis.connect(url: ENV["REDISTOGO_URL"])
end
