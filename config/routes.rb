Seemespeak::Application.routes.draw do

  resources :videos

  resources :reviews

  get "language/:locale", :controller => "locale", :action => "change"

  root      to: "welcome#index"

end
