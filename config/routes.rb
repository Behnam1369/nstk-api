Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/file/:idfile", to: "attachment#show"
  post "/file", to: "attachment#upload"

  get "/users/:iduser/work_missions/new", to: "work_mission#new"
  get "/users/:iduser/work_missions/:idmission", to: "work_mission#show"
  post "/work_missions", to: "work_mission#save_work_mission"
  get "/users/:iduser/work_missions/:idmission/missioners/:idmissioner/payments", to: "work_mission#payments"
  post "/users/:iduser/work_missions/:idmission/missioners/:idmissioner/payments", to: "work_mission#save_payment"
  patch "/users/:iduser/work_missions/:idmission/missioners/:idmissioner/payments/:idpayment", to: "work_mission#delete_payment"
  get "/users/:iduser/work_missions/:idmission/missioners/:idmissioner/reports", to: "work_mission#reports"
  post "/users/:iduser/work_missions/:idmission/missioners/:idmissioner/reports", to: "work_missioner#save_report"
  get "/users/:iduser/work_missions/:idmission/mission_fee", to: "work_mission#show_mission_fee"
  patch "/users/:iduser/work_missions/:idmission/mission_fee", to: "work_mission#save_mission_fee"

  get "/users/:iduser/pr/new", to: "pr#new"
  patch  "/users/:iduser/pr/:idpr/cancel", to: "pr#cancel"
  patch "/users/:iduser/pr/:idpr/delete", to: "pr#delete"
  get "/users/:iduser/pr/:idpr", to: "pr#show"
  post "/pr", to: "pr#save"

  get "/users/:iduser/purchase_request/new", to: "purchase_request#new"
  patch  "/users/:iduser/purchase_request/:idpurchaserequest/cancel", to: "purchase_request#cancel"
  patch "/users/:iduser/purchase_request/:idpurchaserequest/delete", to: "purchase_request#delete"
  get "/users/:iduser/purchase_request/:idpurchaserequest", to: "purchase_request#show"
  get "/purchase_request/get_trade_size", to: "purchase_request#get_trade_size"
  post "/purchase_request", to: "purchase_request#save"

  post "/users/:iduser/pi_pattern", to: "pi_pattern#create"
  patch "/users/:iduser/pi_pattern/:idpipattern", to: "pi_pattern#update"
  get "/users/:iduser/pi/:idpi/pi_pattern/:idpipattern", to: "pi_pattern#show"

  post "/users/:iduser/pi_print", to: "pi_print#create"
  patch "/users/:iduser/pi_print/:idpiprint", to: "pi_print#update"
  get "/users/:iduser/pi_print/:idpiprint", to: "pi_print#show"

  get "/users/:iduser/pi/:idpi/soa", to: "pi#soa"

  get "/users/:iduser/survey", to: "survey#index"
  get "/users/:iduser/survey/:idsurvey", to: "survey#show"
  get "/users/:iduser/survey/:idsurvey/result", to: "survey#result"
  post "/users/:iduser/survey", to: "survey#create"
  patch "/users/:iduser/survey/:idsurvey", to: "survey#update"
  delete "/users/:iduser/survey/:idsurvey", to: "survey#destroy"
  post "/users/:iduser/survey/:idsurvey/vote", to: "survey#vote"

  get "users/:iduser/market_report/search/:search_text", to: "market_report#index"
  get "users/:iduser/market_report/:idmarketreport", to: "market_report#show"
  post "users/:iduser/market_report", to: "market_report#create"
  patch "users/:iduser/market_report/:idmarketreport", to: "market_report#update"
  delete "users/:iduser/market_report/:idmarketreport", to: "market_report#destroy"
  get "users/:iduser/market_report/market_search/:search_term", to: "market_report#top_5_markets_suggestions"
  get "users/:iduser/market_report/product_search/:search_term", to: "market_report#top_5_products_suggestions"

  get "users/:iduser/loan/new", to: "loan#new"
  get "users/:iduser/loan/:idloan/edit", to: "loan#edit"
  post "users/:iduser/loan", to: "loan#create"
  patch "users/:iduser/loan/:idloan/send_to_dept_manager", to: "loan#send_to_dept_manager"
  patch "users/:iduser/loan/:idloan/send_to_hr", to: "loan#send_to_hr"
  patch "users/:iduser/loan/:idloan/send_to_ceo", to: "loan#send_to_ceo"
  patch "users/:iduser/loan/:idloan/send_to_finance", to: "loan#send_to_finance"
  patch "users/:iduser/loan/:idloan/confirm_payment", to: "loan#confirm_payment"
  patch "users/:iduser/loan/:idloan/reject_by_dept_manager", to: "loan#reject_by_dept_manager"
  patch "users/:iduser/loan/:idloan/reject_by_hr", to: "loan#reject_by_hr"
  patch "users/:iduser/loan/:idloan/reject_by_ceo", to: "loan#reject_by_ceo"

  get "users/:iduser/contract/new", to: "contract#new"
  get "users/:iduser/contract/:idcontract", to: "contract#show"
  post "users/:iduser/contract", to: "contract#create"
  patch "users/:iduser/contract/:idcontract", to: "contract#update"
  patch "users/:iduser/contract/:idcontract/cancel", to: "contract#cancel"
  patch "users/:iduser/contract/:idcontract/recover", to: "contract#recover"
  delete "users/:iduser/contract/:idcontract", to: "contract#destroy"

  get "users/:iduser/suggestion", to: "suggestion#new"
  get "users/:iduser/suggestion/:idsuggestion", to: "suggestion#show"
  post "users/:iduser/suggestion", to: "suggestion#create"
  patch "users/:iduser/suggestion/:idsuggestion", to: "suggestion#update"

  post "voyage_dates/voyage_date_items", to: "voyage_date#get_voyage_date_items"
  get "voyage_dates/voyages_dates", to: "voyage_date#get_voyages_dates"
  post "users/:iduser/voyage_dates/register", to: "voyage_date#register"
  post "users/:iduser/voyage_dates/clear", to: "voyage_date#clear"
  post "users/:iduser/voyage_dates/increment", to: "voyage_date#increment"
  post "users/:iduser/voyage_dates/decrement", to: "voyage_date#decrement"

  get "personnel/:idwinkart", to: "user#show"
  get "personnel/:idwinkart/birthdays", to: "user#birthdays"
  post "personnel/:idwinkart/save_birthdays", to: "user#save_birthdays"

  
end
