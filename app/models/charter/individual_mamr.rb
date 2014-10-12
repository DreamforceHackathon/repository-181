class Charter::IndividualMamr # Moving Average Moving Range
  attr_reader :analyzer, :title

  def initialize(analyzer, title: "")
    @analyzer = analyzer
    @title = title
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
    analyzer.data.to_a
  end

  def to_highcharts
    highcharts_formatted_json if values.any?
  end

  private

  def cl_step_size
    @cl_step_size ||= (ucl - cl) / 3
  end

  def highcharts_formatted_json
    {
      title: {
          text: 'Daily Values Chart',
          x: -20 # center
      },
      yAxis: {
        title: {
          text: 'Value'
        },
        min: lcl,
        max: ucl,
        plotLines: [
            {
                color: 'black',
                value: cl,
                width: 3
            },
            {
                color: '#a94442',
                value: ucl,
                width: 1
            },
            {
                color: '#a94442',
                value: lcl,
                width: 1
            }
        ],
        plotBands: [
          {
            color: '#dff0d8',
            from: cl_step(1),
            to: cl_step(-1)
          },
          {
            color: '#fcf8e3',
            from: cl_step(1),
            to: cl_step(2)
          },
          {
            color: '#fcf8e3',
            from: cl_step(-1),
            to: cl_step(-2)
          },
          {
            color: '#f2dede',
            from: cl_step(2),
            to: cl_step(3)
          },
          {
            color: '#f2dede',
            from: cl_step(-2),
            to: cl_step(-3)
          }
        ]
      },

      xAxis: {
        type: "datetime"
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
