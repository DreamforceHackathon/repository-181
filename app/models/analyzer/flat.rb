# Process control for data points that don't cumulate over time, they are flat
class Analyzer::Flat
  attr_reader :data

  def initialize(data)
    @data = data
  end

  # Mean of set
  def x_bar
    mean(values)
  end

  # Average standard deviation correct with Bessel's correction
  def s_bar
    variance = mean(squared_differences, 1)
    Math.sqrt(variance)
  end

  def n
    values.size
  end

  def values
    @values ||= data.values
  end

  # C4 is a difficult value to compute, so use a preknown table which is a bit of a pain in the ass
  def c4
    if n <= 30
      C4_TABLE_THROUGH_30[n-2]
    elsif n <= 40
      0.993611
    elsif n <= 50
      0.994911
    elsif n <= 60
      0.995772
    elsif n <= 70
      0.996383
    elsif n <= 80
      0.996841
    elsif n <= 90
      0.997195
    elsif n <= 1000
      0.9974779761
    else
      0.9997497811 # 1000
    end
  end

  private

  def mean(values, adjust = 0)
    sum = values.inject(0.0){ |sum, i| sum + i }
    sum / (n - adjust)
  end

  def squared_differences
    values.map do |value|
      ( value - x_bar ) * ( value - x_bar )
    end
  end

  C4_TABLE_THROUGH_30 = [ 0.797885, 0.886227, 0.921318, 0.939986, 0.951533, 0.959369, 0.965030, 0.969311, 0.972659, 0.975350, 0.977559, 0.979406, 0.980971, 0.982316, 0.983484, 0.984506, 0.985410, 0.986214, 0.986934, 0.987583, 0.988170, 0.988705, 0.989193, 0.989640, 0.990052, 0.990433, 0.990786, 0.991113, 0.991418]
end
