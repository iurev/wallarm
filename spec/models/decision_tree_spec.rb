require 'rails_helper'

RSpec.describe DecisionTree, type: :model do
  describe '.new' do
    let(:dt) do
      DecisionTree.new({
        key: 'color',
        values: {
          value1: DecisionTree.new,
          value2: [1, 2]
        },
        default: DecisionTree.new,
      })
    end
    it { expect(dt.key).to eq('color') }
    it { expect(dt.values).to be_kind_of(Hash) }
    it { expect(dt.values[:value1]).to be_kind_of(DecisionTree) }
    it { expect(dt.values[:value2]).to be_kind_of(Array) }
    it { expect(dt.default).to be_kind_of(DecisionTree) }
  end

  describe '.construct' do
    describe 'one action' do
      describe 'one key' do
        let!(:action) do
          create(:action, properties: {
            color: 'green'
          })
        end
        let(:dt) { DecisionTree.construct }

        it { expect(dt.key).to eq('color') }
        it { expect(dt.values.length).to eq(1) }
        it { expect(dt.values[0]).to eq(action.id) }
        it { expect(dt.default).to eq([]) }
      end
    end
  end
end
