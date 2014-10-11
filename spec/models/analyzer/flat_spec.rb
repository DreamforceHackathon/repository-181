require 'rails_helper'

RSpec.describe Analyzer::Flat do
  let(:data) {{
    (Time.now - 3.days).strftime("%Y-%m-%d") => 5,
    (Time.now - 2.days).strftime("%Y-%m-%d") => 10,
    (Time.now - 1.days).strftime("%Y-%m-%d") => 15,
    (Time.now - 0.days).strftime("%Y-%m-%d") => 7,
    (Time.now + 1.days).strftime("%Y-%m-%d") => 11
  }}

  subject { Analyzer::Flat.new(data) }

  it "has the right x_bar" do
    expect(subject.x_bar).to eq(9.6)
  end

  it "has the right s_bar" do
    expect(subject.s_bar).to eq(3.85)
  end
end
