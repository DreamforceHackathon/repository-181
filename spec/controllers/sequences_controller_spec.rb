require 'rails_helper'

RSpec.describe SequencesController, type: :controller do

  before(:each) { request.env["HTTP_ACCEPT"] = 'application/json' }

  describe 'show' do
    let!(:sequence) { FactoryGirl.create(:sequence) }

    it "shows the sequence" do
      get :show, id: sequence.id
      expect(response_json["id"]).to eq(sequence.id)
    end

    it "has the normalized data points" do
      sequence.entries.create!(point_time: Time.current, point_value: 1)
      sequence.entries.create!(point_time: Time.current, point_value: 1)
      sequence.entries.create!(point_time: Time.current - 1.days, point_value: 3)

      get :show, id: sequence.id
      expect(response_json["daily_data"]).to eq({
        (Time.current - 1.days).strftime("%Y-%m-%d") => 3.0,
        (Time.current).strftime("%Y-%m-%d") => 2.0
      })
    end
  end

end
