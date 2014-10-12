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

  def cl_step_size
    @cl_step_size ||= (ucl - cl) / 3
  end

  def values
    analyzer.ranges.to_a
  end

  def to_highcharts
    highcharts_formatted_json if values.any?
  end

  def out_of_control_points
    values.inject({}) do |h,pair|
      date = pair[0]
      value = pair[1]
      if value > ucl
        h[date] = value
      end
      h
    end
  end

  private

  def highcharts_formatted_json
    {
      title: {
        text: 'Daily Difference Chart',
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
      xAxis: {
        type: 'datetime',
      },
      series: [
        {
          name: title,
          data: values,
          pointInterval: 24 * 3600 * 1000,
          pointStart: (values.first.first).to_time.to_i * 1000
        }
      ]
    }.to_json
  end
end
