class DecisionTree::ActionWrapper
  attr_accessor :id, :properties

  def initialize(action)
    @id = action.id
    @properties = action.properties.dup
  end

  def clone
    self.class.new(self)
  end

  def remove_key(key)
    properties.delete(key)
    self
  end

  def keys
    @properties.keys.sort
  end

  def key
    keys.first
  end

  def value(key)
    properties[key].to_s.to_sym
  end
end
