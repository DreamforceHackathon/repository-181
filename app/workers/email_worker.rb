class EmailWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    ReportMailer.daily(user).deliver!
  end
end
