Rails.application.routes.draw do
  resources :state, :controller => "state", :only => ["index", "show"]
  root to: 'state#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
