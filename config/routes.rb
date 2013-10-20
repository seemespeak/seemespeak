Seemespeak::Application.routes.draw do

  resources :videos

  resources :reviews

  root      to: "welcome#index"

end
