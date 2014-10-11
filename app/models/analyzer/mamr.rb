# Process control for data points that don't cumulate over time, they are flat
class Analyzer::Mamr
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def ranges
    @range ||= begin
      h = {}

      sorted = data.sort.reverse.to_h
      sorted.each_cons(2) do |slice|
        v1 = slice.first.last
        v2 = slice.last.last
        h[slice.first.first] = (v1-v2).abs
      end

      h.sort.reverse.to_h
    end
  end

  def mean
    _mean(values)
  end

  def mean_range
    _mean(ranges.values)
  end

  private

  def values
    @values ||= data.values
  end

  def _mean(values)
    sum = values.inject(0.0){ |sum, i| sum + i }
    sum / values.size
  end
end
