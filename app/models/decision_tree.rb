class DecisionTree
  include ActiveModel::Model

  attr_accessor :attribute_name # TODO: fix later

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
