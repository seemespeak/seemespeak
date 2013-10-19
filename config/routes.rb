Seemespeak::Application.routes.draw do

  resources :videos

  root      to: "welcome#index"

end
