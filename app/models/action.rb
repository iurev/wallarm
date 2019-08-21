class Action < ApplicationRecord
  def self.by_batches(batch_size)
    self.find_in_batches(batch_size: batch_size) do |actions_batch|
      actions_batch.each do |action|
        yield action
      end
    end
  end
end
