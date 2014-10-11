class Sequence < ActiveRecord::Base
  has_many :entries
  belongs_to :user

  def daily_data
    format_data = entries.map{|e| { date: e.point_time, val: e.point_value } }
    DailyAggregator.new(format_data).data
  end
end
