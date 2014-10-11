require 'rails_helper'

RSpec.describe User, type: :model do
  describe "normalized_sfdc_config" do
    it "has all the fields" do
      expect(User.new.normalized_sfdc_config).to include("leads", "contacts", "opportunities", "activities")
    end

    it "saves the previous value" do
      user = FactoryGirl.create(:user)
      user.update!(sfdc_config: {leads: true})
      expect(user.reload.normalized_sfdc_config["leads"]).to eq(true)
    end
  end
end
