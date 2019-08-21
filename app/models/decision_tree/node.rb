class DecisionTree::Node
  # `String`, one of the `Action#properties`'s keys
  attr_accessor :key

  # `DecisionTree::Values`, all possible values for the given `key`
  attr_accessor :values

  # `DecisionTree::Node`, alternative branch when `Action` doesn't have common `key`
  attr_accessor :default

  # `[DecisionTree::ActionWrapper]`, classified actions
  attr_accessor :end_actions

  def initialize(params = {})
    @values = DecisionTree::Values.new
    @end_actions = []
  end

  def add!(action)
    if action.keys.length == 0
      @end_actions.push(action)
    else
      if !key
        self.key = action.key
        self.values = DecisionTree::Values.new
        self.values.add!(action, self.key)
      else
        if action.keys.include?(self.key)
          self.values.add!(action, self.key)
        else
          @default = self.class.new
          @default.add!(action)
        end
      end
    end
  end

  def to_h
    if end_actions.length >= 1
      if @values.empty?
        return end_actions.map(&:id)
      else
        return {
          key: key,
          values: values.to_h,
          default: end_actions.map(&:id)
        }
      end
    end
    return [] if !key


    d = if default
      default.to_h
    else
      []
    end
    {
      key: key,
      values: values.to_h,
      default: d
    }
  end
end
