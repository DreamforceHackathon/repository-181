require 'rails_helper'

RSpec.describe Analyzer::Mamr do
  let(:data) {{
      (Time.now - 3.days).strftime("%Y-%m-%d") => 5,
      (Time.now - 2.days).strftime("%Y-%m-%d") => 9,
      (Time.now - 1.days).strftime("%Y-%m-%d") => 15,
      (Time.now - 0.days).strftime("%Y-%m-%d") => 7,
      (Time.now + 1.days).strftime("%Y-%m-%d") => 11
  }}

  subject { Analyzer::Mamr.new(data) }

  describe "ranges" do
    it "has the right ranges in the right order" do
      expect(subject.ranges).to eq({
        (Time.now - 2.days).strftime("%Y-%m-%d") => 4,
        (Time.now - 1.days).strftime("%Y-%m-%d") => 6,
        (Time.now - 0.days).strftime("%Y-%m-%d") => 8,
        (Time.now + 1.days).strftime("%Y-%m-%d") => 4
      })
    end
  end
end
