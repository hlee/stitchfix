require 'rails_helper'

RSpec.describe ClearanceBatchesController, :type => :controller do
  let(:clearance_batch) { FactoryGirl.create(:clearance_batch) }

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "POST 'create'" do
    it "return http success" do
      post :create, kind: 'barcodes', barcodes: "123,12,43"
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET 'show'" do
    before do
      get :show, id: clearance_batch.id
    end

    it "returns http success" do
      expect(response).to be_success
    end

    it "should found clearance_batch" do
      expect(assigns(:clearance_batch)).to eq clearance_batch
    end
  end
end
