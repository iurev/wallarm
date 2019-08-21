class Api::V1::ActionsController < Api::V1::ApplicationController
  def index
    render json: Action.all
  end

  def create
    action = Action.new(action_params)
    if action.save
      render json: action
    else
      render json: action.errors.messages, status: 400
    end
  end

  private

  def action_params
    { properties: params[:properties] }
  end
end
