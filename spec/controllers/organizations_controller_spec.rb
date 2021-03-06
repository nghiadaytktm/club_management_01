require "rails_helper"

RSpec.describe OrganizationsController, type: :controller do
  let(:user){create :user}
  let(:organization){create :organization}
  before do
    sign_in user
  end

  describe "GET #index" do
    it "responds successfully" do
      get :index, params: {format: :html}
      expect(response).to be_success
    end
    it "responds successfully" do
      get :index, params: {q: :framgia}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    context "when params present" do
      before{get :show, xhr: true, params: {id: organization}}
      it{expect(response).to be_ok}
    end
    context "when params present" do
      before{get :show, xhr: true, params: {id: organization, page: 2}}
      it{expect(response).to be_ok}
    end
    context "when params not present" do
      before{get :show, params: {id: 0}}
      it{expect(flash[:danger]).to eq I18n.t("organization_not_found")}
    end
  end

  describe "GET #edit" do
    context "when params present" do
      before{get :edit, xhr: true, params: {id: organization}}
      it{expect(response).to be_ok}
    end
    context "when params not present" do
      before{get :edit, params: {id: 0}}
      it{expect(flash[:danger]).to eq I18n.t("organization_not_found")}
    end
  end
end
