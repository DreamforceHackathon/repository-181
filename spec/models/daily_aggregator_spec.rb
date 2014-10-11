require 'rails_helper'

RSpec.describe DailyAggregator do
  let(:data) {[
    { date: Time.current - 4.days, val: 50 },
    { date: Time.current - 3.days, val: 47 },
    { date: Time.current - 2.days, val: 53 },
    { date: Time.current - 1.days, val: 42 },
    { date: Time.current - 1.days * 0.75, val: 7 },
  ]}

  let(:simple_data) {[
    { date: Time.current, val: 10 },
    { date: Time.current - 2.days, val: 15 }
  ]}

  it "groups and sums by day" do
    aggregator = DailyAggregator.new(data)
    expect(aggregator.data).to eq({
      (Time.current - 4.days).to_date => 50,
      (Time.current - 3.days).to_date => 47,
      (Time.current - 2.days).to_date => 53,
      (Time.current - 1.days).to_date => 49
    })
  end

  it "sorts" do
    aggregator = DailyAggregator.new(simple_data)
    expect(aggregator.data).to eq({
      (Time.current-2.days).to_date => 15,
      (Time.current).to_date => 10,
    })
  end
end
