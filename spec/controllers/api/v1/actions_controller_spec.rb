require 'rails_helper'

RSpec.describe Api::V1::ActionsController, type: :controller do
  describe 'GET index' do
    let!(:action) { create(:action) }
    describe 'success' do
      before(:each) { get(:index) }
      it { expect(response.status).to eq(200) }
      it { expect(JSON.parse(response.body)[0]['id']).to eq(action.id) }
    end
  end

  describe 'POST create' do
    describe 'success' do
      let(:request) do
        post(:create, params: {
            properties: {
              value: 1
              }
          }
        )
      end
      it do
        request
        expect(response.status).to eq(200)
      end
      it do
        expect { request }.to change { Action.count }.by(1)
      end
    end

    describe 'failure' do
      let(:request) do
        post(:create, params: {
            properties: 4
          }
        )
      end
      it do
        request
        expect(response.status).to eq(422)
      end
      it do
        expect { request }.not_to change { Action.count }
      end
      it do
        request
        expect(JSON.parse(response.body)).to have_key('properties')
      end
    end
  end
end
