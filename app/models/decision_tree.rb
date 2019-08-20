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

  def self.construct
    action = Action.first
    dt = DecisionTree.new({
      key: Action.first.properties.keys.first,
      values: {}, # TODO: add default initialization
      default: [], # TODO: add default initialization
    })
    dt.values = []
    dt.values.push(action.id)
    dt
  end
end
