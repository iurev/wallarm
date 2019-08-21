class DecisionTree
  ACTIONS_BATCH_SIZE = 500
  include ActiveModel::Model

  # `String`, one of the `Action#properties`'s keys
  attr_accessor :key

  # `DecisionTree::Values`, all possible values for the given `key`
  attr_accessor :values

  # `DecisionTree`, alternative branch when `Action` doesn't have common `key`
  attr_accessor :default

  # `[DecisionTree::ActionWrapper]`, classified actions
  attr_accessor :end_actions

  def initialize(params = {})
    @values = Values.new
    @end_actions = []
  end

  def self.construct()
    top = DecisionTree.new
    self.go_actions_by_batch do |action|
      top.add!(ActionWrapper.new(action))
    end

    top
  end

  def self.go_actions_by_batch
    Action.find_in_batches(batch_size: ACTIONS_BATCH_SIZE) do |actions_batch|
      actions_batch.each do |action|
        yield action
      end
    end
  end

  def add!(action)
    if action.keys.length == 0
      @end_actions.push(action)
    else
      if !key
        self.key = action.key
        self.values = Values.new
        self.values.add!(action, self.key)
      else
        if action.keys.include?(self.key)
          self.values.add!(action, self.key)
        else
          @default = DecisionTree.new
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
