class Charter::Xbar
  attr_reader :analyzer

  def initialize(analyzer)
    @analyzer = analyzer
  end

  def ucl
    cl(3)
  end

  def cl(distance = 0)
    x_bar + distance * (s_bar / analyzer.c4 * Math.sqrt(analyzer.n))
  end

  def lcl
    cl(-3)
  end

  def values
    analyzer.data.to_a.to_json
  end

  private

  def x_bar
    @x_bar ||= analyzer.x_bar
  end

  def s_bar
    @s_bar ||= analyzer.s_bar
  end
end
