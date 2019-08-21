require 'rails_helper'

RSpec.describe DecisionTree::Node, type: :model do
  describe '.new' do
    let(:node) do
      node = DecisionTree::Node.new
      node.key = 'color'
      node.default = DecisionTree::Node.new
      node
    end
    it { expect(node.key).to eq('color') }
    it { expect(node.values).to be_kind_of(DecisionTree::Values) }
    it { expect(node.default).to be_kind_of(DecisionTree::Node) }
  end
end
