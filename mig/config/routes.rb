Rails.application.routes.draw do

  root    "welcome#index"

  get("/welcome/index", to: "welcome#index")
  get("/welcome/login", to: "welcome#login")
  get("/welcome/registration", to: "welcome#registration")
  get("/welcome/show", to: "welcome#show")
  get("/welcome/user_listing", to: "welcome#user_listing")

  post("/welcome/create_new_session", to: "welcome#create_new_session")
  post("/welcome/destroy_session", to: "welcome#destroy_session")
  post("/welcome/create_new_user", to: "welcome#create_new_user")

  resources :welcome


  match(
    "*path",
    :to => redirect("/404"),
    :via => :get
    );

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
