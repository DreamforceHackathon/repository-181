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
        sign_in(FactoryGirl.create(:users))
        get :show
        expect(response_json).to include("id", "name", "organization")
        expect(response_json).not_to include("encrypted_password", "created_at")
      end
    end
  end
end
