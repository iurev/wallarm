class DecisionTree
  ACTIONS_BATCH_SIZE = 500

  def self.construct()
    top_node = Node.new
    self.go_actions_by_batch do |action|
      top_node.add!(ActionWrapper.new(action))
    end

    top_node
  end

  def self.go_actions_by_batch
    Action.find_in_batches(batch_size: ACTIONS_BATCH_SIZE) do |actions_batch|
      actions_batch.each do |action|
        yield action
      end
    end
  end
end
