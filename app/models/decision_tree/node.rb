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
      @end_actions.push(action)
    else
      if key
        if action.keys.include?(key)
          values.add!(action, key)
        else
          @default = self.class.new
          @default.add!(action)
        end
      else
        self.key = action.key
        self.values = DecisionTree::Values.new
        values.add!(action, key)
      end
    end
  end

  def to_hash
    if end_actions.length >= 1
      if @values.empty?
        return end_actions.map(&:id)
      else
        return {
          key: key,
          values: values.to_hash,
          default: end_actions.map(&:id)
        }
      end
    end
    return [] unless key

    d = if default
      default.to_hash
    else
      []
    end
    {
      key: key,
      values: values.to_hash,
      default: d
    }
  end
end
