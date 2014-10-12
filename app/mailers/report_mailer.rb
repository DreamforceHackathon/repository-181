class ReportMailer < ActionMailer::Base
  default from: 'sb8244@cs.ship.edu'

  def daily(user)
    @user = user

    if user.sfdc_setup
      @subject = "Daily Sales Process Report"
    else
      @subject = "Daily Process Report"
    end

    @charts = {}
    @user.sequences.where(active: true).each do |sequence|
      @charts[sequence] = charts_for(sequence)
    end

    mail(to: @user.email, subject: @subject)
  end

  private

  def charts_for(sequence)
    analyzer = Analyzer::Mamr.new(sequence.daily_data)
    range_mamr = Charter::RangeMamr.new(analyzer, title: sequence.title)
    indiv_mamr = Charter::IndividualMamr.new(analyzer, title: sequence.title)
    mamr_renderer = Charter::ServerRender.new(input: indiv_mamr.to_highcharts, width: 900)
    range_renderer = Charter::ServerRender.new(input: range_mamr.to_highcharts, width: 900)

    {}.tap do |charts|
      charts[:mamr] = @user.chart_instances.create!(image: mamr_renderer.file)
      charts[:range] = @user.chart_instances.create!(image: range_renderer.file)
      charts[:out_of_control] = range_mamr.out_of_control_points.merge(indiv_mamr.out_of_control_points)
      mamr_renderer.close
      range_renderer.close
    end
  end
end
