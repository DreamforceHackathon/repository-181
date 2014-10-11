class Charter::Sbar
  attr_reader :analyzer

  def initialize(analyzer)
    @analyzer = analyzer
  end

  def ucl
    cl(3)
  end

  def cl(distance = 0)
    s_bar + (distance * s_bar / analyzer.c4) * Math.sqrt(1 - (analyzer.c4 * analyzer.c4))
  end

  def lcl
    cl(-3)
  end

  def values
    @values ||= begin
      # construct a new hash of date -> deviation pairs
      analyzer.data.inject({}) do |h, (k, v)|
        h[k] = Math.sqrt((v - analyzer.x_bar) * (v - analyzer.x_bar))
        h
      end
    end.to_a.to_json
  end

  private

  def s_bar
    @s_bar ||= analyzer.s_bar
  end
end
