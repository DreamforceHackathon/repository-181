class DailyAggregator

  # [ { date:, :val } , ... ]
  def initialize(points)
    @points = points
  end

  def data
    @data ||= begin
      aggregate_by_date.sort.to_h
    end
  end

  private

  def aggregate_by_date
    aggregate = @points.group_by{ |entry| entry[:date].to_date }

    aggregate.each do |date, entries|
      total = entries.inject(0) do |sum, entry|
        sum + entry[:val]
      end

      aggregate[date] = total # Map won't keep the original associations
    end
  end
end
