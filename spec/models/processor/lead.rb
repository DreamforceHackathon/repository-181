require 'rails_helper'

RSpec.describe Processor::Lead do
  let!(:sequence) { FactoryGirl.create(:sequence, processor: "Processor::Lead") }
  let!(:user) { sequence.user }

  context "with restforce" do
    let(:search_double) { double }
    before(:each) do
      expect(user).to receive(:restforce).and_return(search_double).at_least(1).times
      expect(search_double).to receive(:query).and_return(double(size: 5))
    end

    it "creates a point" do
      expect {
        Processor::Lead.new(sequence.user, Time.now).call!
      }.to change{ sequence.entries.count }.by(1)

      expect(sequence.entries.last.point_value).to eq(5)
      expect(sequence.entries.last.source).to eq("processor")
    end

    it "removes old processor points from that day" do
      entry = sequence.entries.create!(source: "processor", point_value: 1, point_time: Time.now)

      expect {
        Processor::Lead.new(sequence.user, Time.now).call!
      }.to change{ sequence.entries.count }.by(0)

      expect(sequence.entries.first.point_value).to eq(5)
    end

    it "doesn't remove old processor points from other day" do
      entry = sequence.entries.create!(source: "processor", point_value: 1, point_time: Time.now + 1.day)

      expect {
        Processor::Lead.new(sequence.user, Time.now).call!
      }.to change{ sequence.entries.count }.by(1)
    end
  end

  context "without restforce" do
    it "doesn't create a point" do
      expect {
        Processor::Lead.new(sequence.user, Time.now).call!
      }.not_to change{ sequence.entries.count }
    end
  end
end
