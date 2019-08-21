class DecisionTree
  include ActiveModel::Model

  # `String`, `Actions`'s key
  attr_accessor :key

  <<-DOC
    `Hash` or `[Number]`
    All keys present all possible values for the given `key`
    If value is `DecisionTree` – tree goes further
    If value is array of numbers – action is classified
    ```
      {
        value1: <DecisionTree>,
        value2: <DecisionTree>,
        value3: [1, 2]
      }
    ```
  DOC
  attr_accessor :values

  # TODO: (?) change empty `[Number]` to `DecisionTree`
  <<-DOC
    `DecisionTree` or `[Number]`,
    alternative branch when `Action` doesn't have common `key`

    If value is `DecisionTree` – it classifies action by another `key`
    If value is array of numbers – TODO (?)
    ```
      default: <DecisionTree>
    ```
    or
    ```
      default: [] # TODO
    ```
  DOC
  attr_accessor :default

  def initialize(params = {})
    @key = params[:key]
    @values = Values.new
    @default = params[:default]

    @end_actions = []
  end

  def self.construct()
    top = DecisionTree.new
    Action.all.each do |action|
      top.add!(ActionWrapper.new(action))
    end

    top
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
    if @end_actions.length >= 1
      if @values.empty?
        return @end_actions.map(&:id)
      else
        return {
          key: key,
          values: values.to_h,
          default: @end_actions.map(&:id)
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
