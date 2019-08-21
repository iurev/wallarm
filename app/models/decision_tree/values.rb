class DecisionTree::Values
  def initialize
    @hash = {}
  end

  def add!(action, action_key)

    new_action = action.clone.remove_key(action_key)
    v = action.properties[action_key].to_sym
    if @hash.keys.length >= 1
      if @hash[v]
        dt = @hash[v]
        dt.add!(new_action)
      else
        dt = DecisionTree.new
        dt.add!(new_action)
        @hash[v] = dt
      end
    else
      dt = DecisionTree.new
      dt.add!(new_action)
      @hash[v] = dt
    end
  end

  def empty?
    @hash.keys.length === 0
  end

  def to_h
    hvalues = {}
    @hash.keys.each do |key|
      hvalues[key] = @hash[key].to_h
    end
    hvalues
  end
end
