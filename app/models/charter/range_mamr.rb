class Charter::RangeMamr
  attr_reader :analyzer, :title

  def initialize(analyzer, title: "")
    @analyzer = analyzer
    @title = title
  end

  def cl
    analyzer.mean_range
  end

  def cl_step(amount)
    cl + amount * cl_step_size
  end

  def ucl
    cl + 3.267 * analyzer.mean_range
  end

  def lcl
    0
  end

  def values
    analyzer.ranges.to_a
  end

  def to_highcharts
    highcharts_formatted_json
  end

  private

  def cl_step_size
    @cl_step_size ||= (ucl - cl) / 3
  end

  def highcharts_formatted_json
    {
      title: {
        text: 'Range MaMR Chart',
        x: -20 # center
      },
      yAxis: {
        title: {
          text: 'Value'
        },
        min: lcl,
        max: ucl,
        plotBands: [
          {
            color: '#dff0d8',
            from: cl_step(1),
            to: lcl
          },
          {
            color: '#fcf8e3',
            from: cl_step(1),
            to: cl_step(2)
          },
          {
            color: '#f2dede',
            from: cl_step(2),
            to: cl_step(3)
          }
        ]
      },

      series: [
        {
          name: title,
          data: values
        }
      ]
    }.to_json
  end
end
