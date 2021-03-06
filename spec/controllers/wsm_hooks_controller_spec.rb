require "rails_helper"

RSpec.describe WsmHooksController, type: :controller do
  let!(:user){create :user}

  describe "POST #destroy_user" do
    let :params_valid do
      {
        action: "deleted",
        user:
        {
          name: user.full_name,
          email: user.email,
          deleted_at: Date.today
        }
      }
    end

    let :params_invalid do
      {
        action: "deleted",
        user: {}
      }
    end

    let :params_update do
      {
        action: "updated",
        user:
        {
          name: "Dao Van Nam",
          email: user.email,
          deleted_at: Date.today
        }
      }
    end

    context "Post #update" do
      it "destroy success with valid access_token" do
        expect do
          post :update, body: params_valid.to_json, format: :json,
          params: {access_token: "ada90e4a08622824007d55bc6b90009c5bcd0bd0ae95334e46466dde83c98e072609d0c89b2aac6f7d46e73e33440888549e2a3bfd73334613ec8d900a247aa9"}
        end.to change(User, :count).by -1
      end

      it "destroy fail with invalid access_token" do
        expect do
          post :update, body: params_valid.to_json, format: :json,
          params: {access_token: "da90e4a08622824007d55bc6b90009c5bcd0bd0ae95334e46466dde83c98e072609d0c89b2aac6f7d46e73e33440888549e2a3bfd73334613ec8d900a247aa9"}
        end.to change(User, :count).by 0
      end

      it "destroy fail with valid nil params" do
        expect do
          post :update, body: params_invalid.to_json, format: :json,
          params: {access_token: "ada90e4a08622824007d55bc6b90009c5bcd0bd0ae95334e46466dde83c98e072609d0c89b2aac6f7d46e73e33440888549e2a3bfd73334613ec8d900a247aa9"}
        end.to change(User, :count).by 0
      end

      it "update success with valid params" do
        expect do
          post :update, body: params_update.to_json, format: :json,
          params: {access_token: "ada90e4a08622824007d55bc6b90009c5bcd0bd0ae95334e46466dde83c98e072609d0c89b2aac6f7d46e73e33440888549e2a3bfd73334613ec8d900a247aa9"}
        end.to change{user.reload.full_name}.from(user.full_name).to("Dao Van Nam")
      end
    end
  end
end
