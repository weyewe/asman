Asman::Application.routes.draw do
  devise_for :users
  root :to => 'home#dashboard'
  
=begin
  First Step: setup data, create machine categories  & Create machine
=end
  resources :machine_categories  do
    resources :machines
  end
  
  resources :component_categories 
  
  resources :machines do 
    resources :components 
  end
  
  match 'select_machine_category_to_create_machine' => "machine_categories#select_machine_category_to_create_machine", :as => :select_machine_category_to_create_machine 
  match 'select_machine_to_create_component' => "machines#select_machine_to_create_component", :as => :select_machine_to_create_component

end
