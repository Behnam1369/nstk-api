Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post "/file", to: "attachment#upload"

  get "/users/:iduser/work_missions/new", to: "work_mission#new"
  get "/users/:iduser/work_missions/:idmission", to: "work_mission#show"
  post "/work_missions", to: "work_mission#save_work_mission"
end
