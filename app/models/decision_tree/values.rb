class DecisionTree::Values
  <<-DOC
    `Hash` where each value is a `DecisionTree::Node`
    All keys present all possible values for the given `key`
    ```
      {
        value1: <DecisionTree::Node>,
        value2: <DecisionTree::Node>,
      }
    ```
  DOC
  attr_accessor :hash

  def initialize
    @hash = {}
  end

  def add!(action, action_key)
    new_action = action.clone.remove_key(action_key)
    v = action.properties[action_key].to_s.to_sym
    if hash.keys.length >= 1
      if hash[v]
        dt = hash[v]
        dt.add!(new_action)
      else
        dt = DecisionTree::Node.new
        dt.add!(new_action)
        hash[v] = dt
      end
    else
      dt = DecisionTree::Node.new
      dt.add!(new_action)
      hash[v] = dt
    end
  end

  def empty?
    hash.keys.empty?
  end

  def to_hash
    hvalues = {}
    hash.keys.each do |key|
      hvalues[key] = hash[key].to_hash
    end
    hvalues
  end
end
