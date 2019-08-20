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
      default: [1, 2] # TODO
    ```
  DOC
  attr_accessor :default

  def self.construct
    {
      key: 'color',
      values: {
        green: {
          key: 'location',
          values: {
            unknown: [11]
          },
          default: []
        },
        red: {
          key: 'real',
          values: {
            no: [12]
          },
          default: []
        }
      },
      default: {
        key: 'location',
        values: {
          Moscow: [13]
        },
        default: []
      }
    }
  end
end
