class SequenceSerializer < ActiveModel::Serializer
  attributes :id, :updated_at, :title, :active, :charts

  def include_charts?
    options[:charts]
  end

  def charts
    analyzer = Analyzer::Mamr.new(object.daily_data)
    {
        mamr: Charter::IndividualMamr.new(analyzer).to_highcharts,
        range_mamr: Charter::RangeMamr.new(analyzer).to_highcharts
    }
  end
end
