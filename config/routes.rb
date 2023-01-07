Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post "/file", to: "attachment#upload"

  get "/users/:iduser/work_missions/new", to: "work_mission#new"
  get "/users/:iduser/work_missions/:idmission", to: "work_mission#show"
  post "/work_missions", to: "work_mission#save_work_mission"
  get "/users/:iduser/work_missions/:idmission/missioners/:idmissioner/payments", to: "work_mission#payments"
  post "/users/:iduser/work_missions/:idmission/missioners/:idmissioner/payments", to: "work_mission#save_payment"
  patch "/users/:iduser/work_missions/:idmission/missioners/:idmissioner/payments/:idpayment", to: "work_mission#delete_payment"

  get "/users/:iduser/pr/new", to: "pr#new"
  patch  "/users/:iduser/pr/:idpr/cancel", to: "pr#cancel"
  patch "/users/:iduser/pr/:idpr/delete", to: "pr#delete"
  get "/users/:iduser/pr/:idpr", to: "pr#show"
  post "/pr", to: "pr#save"
end
