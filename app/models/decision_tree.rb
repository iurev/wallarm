class DecisionTree
  ACTIONS_BATCH_SIZE = 500

  def self.construct
    top_node = Node.new
    Action.by_batches(ACTIONS_BATCH_SIZE) do |action|
      top_node.add!(ActionWrapper.new(action))
    end

    top_node
  end
end
