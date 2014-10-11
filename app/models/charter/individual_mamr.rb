class Charter::IndividualMamr # Moving Average Moving Range
  attr_reader :analyzer

  def initialize(analyzer)
    @analyzer = analyzer
  end

  def cl
    analyzer.mean
  end

  def cl_step(amount)
    cl + amount * cl_step_size
  end

  def ucl
    cl + 2.66 * analyzer.mean_range
  end

  def lcl
    cl - 2.66 * analyzer.mean_range
  end

  def values
    analyzer.data.to_a.to_json
  end

  private

  def cl_step_size
    @cl_step_size ||= (ucl - cl) / 3
  end

end
