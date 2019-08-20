require 'rails_helper'

RSpec.describe DecisionTree, type: :model do
  describe '.returns_true' do
    it 'success' do
      expect(subject.class.returns_true).to be_truthy
    end
  end
end
