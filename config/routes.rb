Seemespeak::Application.routes.draw do

  resources :videos do
    member do
  	  get 'up_vote'
      get 'down_vote'
  	end
  end

  resources :reviews do
    member do
  	  get 'mark_as_moderated'
  	end
  end

  get "language/:locale", :controller => "locale", :action => "change"

  root      to: "welcome#index"

end
