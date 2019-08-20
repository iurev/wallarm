require 'rails_helper'

RSpec.describe DecisionTree, type: :model do
  describe '.construct' do
    it 'success' do
      expect(subject.class.construct).to be_kind_of(Hash)
    end
  end
end
