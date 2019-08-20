class Api::V1::DecisionTreeController < Api::V1::ApplicationController
  def index
    # result = DecisionTree.construct
    render json: {}
  end
end
