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
    it 'success' do
      expect(subject.class.construct).to be_kind_of(Hash)
    end
  end
end
