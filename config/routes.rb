Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope :api do
    scope :v1 do
      resources :actions, only: [:index, :create], controller: 'api/v1/actions'
      get '/decision_tree', controller: 'api/v1/decision_tree', action: :index
    end
  end
end
