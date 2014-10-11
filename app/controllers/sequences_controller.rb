class SequencesController < ApiController
  def show
    respond_with sequence, serializer: SequenceDataSerializer
  end

  def chart
    analyzer = Analyzer::Mamr.new(sequence.daily_data)
    range_mamr = Charter::RangeMamr.new(analyzer)
    indiv_mamr = Charter::IndividualMamr.new(analyzer)
    renderer = Charter::ServerRender.new(input: indiv_mamr.to_highcharts, width: 900)

    chart = ChartInstance.create!(image: renderer.file)
    renderer.close

    render json: { url: chart.image.url }
  end

  private

  def sequences
    @sequences ||= Sequence.all
  end

  def sequence
    @sequence ||= sequences.find(params[:id])
  end
end
