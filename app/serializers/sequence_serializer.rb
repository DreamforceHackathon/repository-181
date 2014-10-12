class SequenceSerializer < ActiveModel::Serializer
  attributes :id, :updated_at, :title, :active, :charts, :daily_data

  def include_charts?
    options[:charts]
  end

  def include_daily_data?
    options[:daily_data]
  end

  def charts
    analyzer = Analyzer::Mamr.new(object.daily_data)
    mamr = Charter::IndividualMamr.new(analyzer)
    range_mamr = Charter::RangeMamr.new(analyzer)

    {
      mamr: {
        chart: mamr.to_highcharts,
        out_of_control: mamr.out_of_control_points
      },
      range_mamr: {
        chart: range_mamr.to_highcharts,
        out_of_control: range_mamr.out_of_control_points
      }
    }
  end
end
