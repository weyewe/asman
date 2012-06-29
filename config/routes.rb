Asman::Application.routes.draw do
  devise_for :users
  root :to => 'home#dashboard'
  

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
  resources :spare_parts
  
  resources :compatibilities 
  
  resources :clients do
    resources :assets 
  end
  
  resources :component_statuses
  

# CUSTOM ROUTES 
=begin
  First Step: setup data, create machine categories  & Create machine
=end
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

  
  
  match 'select_client_to_create_asset' => 'clients#select_client_to_create_asset', :as => :select_client_to_create_asset

=begin
  STEP 3: Create Maintenance 
=end

  match 'select_client_to_create_maintenance' => 'clients#select_client_to_create_maintenance', :as => :select_client_to_create_maintenance
  match 'select_asset_to_create_maintenance/:client_id' => 'assets#select_asset_to_create_maintenance', :as => :select_asset_to_create_maintenance
  match 'new_maintenance_for_asset/:asset_id' => 'maintenances#new_maintenance_for_asset', :as => :new_maintenance_for_asset
  match 'create_maintenance_for_asset/:asset_id' => 'maintenances#create_maintenance_for_asset', :as => :create_maintenance_for_asset, :method => :post
  
=begin
  STEP 4 : Select Maintenance to be done 
=end
  match 'select_unfinalized_maintenance_to_be_done' => 'maintenances#select_unfinalized_maintenance_to_be_done', :as => :select_unfinalized_maintenance_to_be_done
  match 'component_status_data_entry_for_maintenance/:maintenance_id' => 'maintenances#component_status_data_entry_for_maintenance', :as => :component_status_data_entry_for_maintenance
  match 'initial_component_status_marking' => 'component_statuses#initial_component_status_marking', :as => :initial_component_status_marking, :method => :post 
  match 'mark_component_status' => 'component_statuses#mark_component_status', :as => :mark_component_status, :method => :post 
  
  match 'finalize_maintenance' => 'maintenances#finalize_maintenance', :as => :finalize_maintenance, :method => :post 
end
