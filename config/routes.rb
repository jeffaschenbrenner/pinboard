Rails.application.routes.draw do
  devise_for :users
  resources :pins do
  	member do
  		put "upvote", to: "pins#upvote"
  		put "downvote", to: "pins#downvote"
  	end
  end

  root 'pins#index'
end
