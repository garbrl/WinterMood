Rails.application.routes.draw do

  get 'dataentry/index'

  root    "welcome#index"

  get("/welcome/index", to: "welcome#index")
  get("/welcome/login", to: "welcome#login")
  get("/welcome/registration", to: "welcome#registration")
  get("/welcome/show", to: "welcome#show")
  get("/welcome/user_listing", to: "welcome#user_listing")

  get("/dataentry/index", to: "dataentry#index")



  post("/welcome/create_new_session", to: "welcome#create_new_session")
  post("/welcome/destroy_session", to: "welcome#destroy_session")
  post("/welcome/create_new_user", to: "welcome#create_new_user")

  post("/dataentry/add_data", to: "dataentry#add_data")




  resources :welcome

  match("/403", :to => redirect("/errors/403"), :via => :get)
  match("/404", :to => redirect("/errors/404"), :via => :get)
  match("/422", :to => redirect("/errors/422"), :via => :get)
  match("/500", :to => redirect("/errors/500"), :via => :get)


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
