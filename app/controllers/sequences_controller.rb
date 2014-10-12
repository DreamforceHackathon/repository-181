class SequencesController < ApiController
  before_filter :authenticate_user!
  def index
    respond_with sequences.where(active: true), charts: true
  end

  def show
    respond_with sequence, charts: true, daily_data: true
  end

  def chart
    analyzer = Analyzer::Mamr.new(sequence.daily_data)
    range_mamr = Charter::RangeMamr.new(analyzer)
    indiv_mamr = Charter::IndividualMamr.new(analyzer)
    renderer = Charter::ServerRender.new(input: indiv_mamr.to_highcharts, width: 900)

    chart = current_user.chart_instances.create!(image: renderer.file)
    renderer.close

    render json: { url: chart.image.url }
  end

  private

  def sequences
    @sequences ||= current_user.sequences
  end

  def sequence
    @sequence ||= sequences.find(params[:id])
  end
end
