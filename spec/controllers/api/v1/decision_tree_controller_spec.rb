require 'rails_helper'

RSpec.describe Api::V1::DecisionTreeController, type: :controller do
  describe 'GET index' do
    it 'success' do
      get :index
      expect(response.status).to eq(200)
    end
  end
end
