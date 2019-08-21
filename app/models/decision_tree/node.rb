class DecisionTree::Node
  # `String`, one of the `Action#properties`'s keys
  attr_accessor :key

  # `DecisionTree::Values`, all possible values for the given `key`
  attr_accessor :values

  # `DecisionTree::Node`, alternative branch when `Action` doesn't have common `key`
  attr_accessor :default

  # `[DecisionTree::ActionWrapper]`, classified actions
  attr_accessor :end_actions

  def initialize
    @values = DecisionTree::Values.new
    @end_actions = []
  end

  def add!(action)
    if action.keys.empty?
      end_actions.push(action)
    else
      if key
        if action.keys.include?(key)
          add_to_values(action, key)
        else
          add_to_default(action)
        end
      else
        init_key(action)
      end
    end
  end

  def to_hash
    if !end_actions.empty? && values.empty?
      return end_actions.map(&:id)
    end
    return [] unless key

    {
      key: key,
      values: values.to_hash,
      default: default_to_hash
    }
  end

  private

  def default_to_hash
    if end_actions.length >= 1
      return end_actions.map(&:id)
    end

    if default
      default.to_hash
    else
      []
    end
  end

  def add_to_values(action, key)
    values.add!(action, key)
  end

  def add_to_default(action)
    self.default = self.class.new unless default
    default.add!(action)
  end

  def init_key(action)
    self.key = action.key
    self.values = DecisionTree::Values.new
    add_to_values(action, key)
  end
end
