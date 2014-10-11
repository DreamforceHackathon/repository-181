require 'rails_helper'

RSpec.describe EntriesController, type: :controller do
  let!(:sequence) { FactoryGirl.create(:sequence) }

  before(:each) { request.env["HTTP_ACCEPT"] = 'application/json' }

  describe "index" do
    let!(:entry) { FactoryGirl.create(:entry, sequence: sequence) }
    let!(:entry2) { FactoryGirl.create(:entry, sequence: sequence) }
    let!(:entry3) { FactoryGirl.create(:entry, sequence: FactoryGirl.create(:sequence)) }

    it "lists the entries" do
      get :index, sequence_id: sequence.id
      expect(response_json.count).to eq(2)
    end
  end

  describe "show" do
    let!(:entry) { FactoryGirl.create(:entry, sequence: sequence) }

    it "shows it" do
      get :show, sequence_id: sequence.id, id: entry.id
      expect(response_json["id"]).to eq(entry.id)
    end
  end

  describe "create" do
    let(:time) { Time.now - 5.hours }

    context "with a time" do
      it "creates a basic entry" do
        expect {
          post :create, sequence_id: sequence.id, point_time: time, point_value: 50
        }.to change{ sequence.entries.count }.by(1)

        expect(Entry.last.point_time.to_i).to eq(time.to_i)
      end
    end

    context "with no time" do
      it "creates the entry with the current time" do
        travel_to(Time.parse("11:50 PM")) do
          post :create, sequence_id: sequence.id, point_value: 50
          expect(Entry.last.point_time).to eq(Time.now)
        end
      end
    end

    context "with eod time" do
      context "before midnight" do
        it "creates the time for the end of today" do
          travel_to(Time.current.end_of_day - 10.minutes) do
            post :create, sequence_id: sequence.id, point_value: 50, point_time: "eod"
            expect(Entry.last.point_time).to be_within(0.000001).of(Time.current.end_of_day)
          end
        end
      end

      context "after midnight" do
        it "creates the time for the end of the previous day" do
          travel_to(Time.current.end_of_day + 10.minutes) do
            post :create, sequence_id: sequence.id, point_value: 50, point_time: "eod"
            expect(Entry.last.point_time).to be_within(0.000001).of(Time.current.beginning_of_day - 1.second)
          end
        end
      end
    end
  end
end
