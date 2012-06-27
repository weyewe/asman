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
  
  resources :components do
    resources :spare_parts
  end
  
  resources :compatibilities 
  
  match 'select_machine_category_to_create_machine' => "machine_categories#select_machine_category_to_create_machine", :as => :select_machine_category_to_create_machine 
  match 'select_machine_to_create_component' => "machines#select_machine_to_create_component", :as => :select_machine_to_create_component

=begin
  Creating spare part
=end
  match 'select_machine_to_create_and_assign_spare_part' => 'machines#select_machine_to_create_and_assign_spare_part', :as => :select_machine_to_create_and_assign_spare_part
  match 'select_component_to_create_and_assign_spare_part/:machine_id' => 'components#select_component_to_create_and_assign_spare_part', :as => :select_component_to_create_and_assign_spare_part
  
  match 'select_component_category_to_create_spare_part' => 'component_categories#select_component_category_to_create_spare_part', :as => :select_component_category_to_create_spare_part


=begin
  Second Step : Create Client + Register Their Assets
=end

  resources :clients do
    resources :assets
  end
  
  resources :assets 
end
