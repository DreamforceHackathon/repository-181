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

  # I'm not proud of this. It's 32 hours in.
  def out_of_control_points
    points_2_3_above = []
    points_2_3_below = []
    points_4_5_above = []
    points_4_5_below = []
    points_8_above = []
    points_8_below = []

    values.inject({}) do |h, pair|
      date = pair.first
      value = pair.last

      if value > ucl
        h[date] = value
      end

      if value < lcl
        h[date] = value
      end

      if value > cl + cl_step_size * 2
        points_2_3_above << pair
        if points_2_3_above.size >= 2
          points_2_3_above.each do |dv|
            h[dv.first] = dv.last
          end
        end
      else
        points_2_3_above.clear
      end

      if value < cl - cl_step_size * 2
        points_2_3_below << pair
        if points_2_3_below.size >= 2
          points_2_3_below.each do |dv|
            h[dv.first] = dv.last
          end
        end
      else
        points_2_3_below.clear
      end

      if value > cl + cl_step_size * 1
        points_4_5_above << pair
        if points_4_5_above.size >= 4
          points_4_5_above.each do |dv|
            h[dv.first] = dv.last
          end
        end
      else
        points_4_5_above.clear
      end

      if value < cl - cl_step_size * 1
        points_4_5_below << pair
        if points_4_5_below.size >= 4
          points_4_5_below.each do |dv|
            h[dv.first] = dv.last
          end
        end
      else
        points_4_5_below.clear
      end

      if value > cl
        points_8_above << pair
        if points_8_above.size >= 8
          points_8_above.each do |dv|
            h[dv.first] = dv.last
          end
        end
      else
        points_8_above.clear
      end

      if value < cl
        points_8_below << pair
        if points_8_below.size >= 8
          points_8_below.each do |dv|
            h[dv.first] = dv.last
          end
        end
      else
        points_8_below.clear
      end

      h
    end
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
