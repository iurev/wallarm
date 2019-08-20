class DecisionTree
  include ActiveModel::Model

  attr_accessor :attribute_name # TODO: fix later

  def self.returns_true
    true
  end
end
