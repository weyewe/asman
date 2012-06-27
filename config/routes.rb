Asman::Application.routes.draw do
  devise_for :users
  root :to => 'home#dashboard'
  
=begin
  First Step: setup data, create machine categories 
=end
  resources :machine_categories 
end
