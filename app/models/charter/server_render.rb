# https://raw.githubusercontent.com/kbaum/highchart-image-api/master/app/models/chart_image.rb
class Charter::ServerRender
  attr_reader :input, :width

  def initialize(input:, width: 300)
    @input, @width = input, width
  end

  def file
    @file ||= generate_chart
  end

  def size
    file.size
  end

  def file_path
    file.path
  end

  def close
    file.close
    infile.close
  end

  private

  def uuid
    @uuid ||= SecureRandom.uuid
  end

  def infile_path
    infile.path
  end

  def infile
    @infile ||= Tempfile.open(["infile-#{uuid}", '.json']) do |out|
      out.write input
      puts input
      out
    end
  end

  def generate_chart
    temp_file = Tempfile.new(["chart-#{uuid}", '.png'])
    temp_file.binmode
    Rails.logger.info %x[phantomjs ./app/javascript/highcharts-convert.js -infile #{infile_path} -outfile #{temp_file.path} -width #{width} 2>&1]
    temp_file
  end
end
