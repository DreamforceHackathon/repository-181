class EmailAggregator
  include Sidekiq::Worker

  def perform
    User.where.not(email: nil).each do |user|
      EmailWorker.perform_async(user.id)
    end
  end
end
