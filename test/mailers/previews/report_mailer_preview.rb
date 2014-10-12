class ReportMailerPreview < ActionMailer::Preview
  def daily
    ReportMailer.daily(User.first)
  end
end
