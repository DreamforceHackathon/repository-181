require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  before(:each) { request.env["HTTP_ACCEPT"] = 'application/json' }

  describe "create" do
    context "without sfdc" do
      it "creates a user" do
        expect {
          post :create, name: "Steve", organization: "SalesLoft", email: "test@test.com", password: "12345678"
        }.to change{ User.count }.by(1)
      end

      it "signs in the user" do
        post :create, name: "Steve", organization: "SalesLoft", email: "test@test.com", password: "12345678"
        expect(controller.current_user).to eq(User.last)
      end
    end

    context "with sfdc" do
      it "doesn't need the email and password" do
        expect {
          post :create, name: "Steve", organization: "SalesLoft"
        }.to change{ User.count }.by(1)
      end
    end
  end

  describe "show" do
    context "without a user" do
      it "is 404" do
        get :show
        expect(response.status).to eq(404)
      end
    end

    context "with a user" do
      it "has the user" do
        sign_in(FactoryGirl.create(:user))
        get :show
        expect(response_json).to include("id", "name", "organization")
        expect(response_json).not_to include("encrypted_password", "created_at")
      end
    end
  end

  describe "configure_sfdc" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) { sign_in(user) }

    it "updates the config" do
      expect {
        post :configure_sfdc, sfdc_config: { leads: true }
      }.to change{ user.reload.sfdc_config["leads"] }.from(nil).to(true)
    end

    it "marks the user configured" do
      expect {
        post :configure_sfdc
      }.to change{ user.reload.sfdc_setup }.from(false).to(true)
    end

    it "creates a single sequence" do
      expect {
        post :configure_sfdc, sfdc_config: { leads: true }
      }.to change{ user.sequences.count }.by(1)

      expect(user.sequences.last.processor).to eq("Processor::Lead")
    end

    it "creates workers" do
      expect {
        post :configure_sfdc, sfdc_config: { leads: true }
      }.to change{ SequenceWorker::jobs.size }.by(90)

    end

    it "creates many sequences" do
      expect {
        post :configure_sfdc, sfdc_config: { leads: true, contacts: true }
      }.to change{ user.sequences.count }.by(2)
    end

    it "doesn't double create" do
      user.sequences.create!(title: "Test", processor: "Processor::Lead")
      expect {
        post :configure_sfdc, sfdc_config: { leads: true }
      }.not_to change{ user.sequences.count }
    end
  end
end
