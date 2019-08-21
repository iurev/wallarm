require 'rails_helper'

RSpec.describe Action, type: :model do
  describe 'validations' do
    describe '#properties' do
      describe 'valid json' do
        let(:action) { create(:action, properties: { value: 1 }) }
        it { expect(action).to be_valid }
      end
      describe 'invalid json' do
        let(:action) { build(:action, properties: 4) }
        it { expect(action).not_to be_valid }
        it do
          action.valid?
          expect(action.errors).to have_key(:properties)
        end
      end
    end
  end
  describe 'create' do
    it 'success' do
      expect { Action.create(properties: { value: 1 }) }.to change { Action.count }.by(1)
    end
    it 'fail' do
      expect { Action.create(properties: 4) }.not_to change { Action.count }
    end
  end
end
