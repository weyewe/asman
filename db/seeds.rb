puts "Maintenance Service Invoicing: maserv"

puts "\n*********APPLICATION WIDE SETUP*********\n"
puts "creating roles"
manager_role = Role.create :name => USER_ROLE[:manager]
machine_builder_role = Role.create :name => USER_ROLE[:machine_builder]
data_entry_role   = Role.create :name => USER_ROLE[:data_entry]
technician_role   = Role.create :name => USER_ROLE[:technician]
account_manager_role = Role.create :name => USER_ROLE[:account_manager]
cashier_role = Role.create :name => USER_ROLE[:cashier]




puts "*********OFFICE WIDE SETUP***********"
puts "creating office"
dikarunia_office = Office.create :name => "Dikarunia"


puts "creating user"
manager = dikarunia_office.create_user( [manager_role], 
                  :email => 'manager@gmail.com',
                  :password => 'willy1234',
                  :password_confirmation => 'willy1234'  )
data_entry = dikarunia_office.create_user( [data_entry_role], 
                  :email => "data_entry@gmail.com", 
                  :password => "willy1234",
                  :password_confirmation => "willy1234" )  #, :office_id => dikarunia_office.id
                  
cashier =   dikarunia_office.create_user( [cashier_role], 
                    :email => "cashier@gmail.com", 
                    :password => "willy1234",
                    :password_confirmation => "willy1234" )

technician = dikarunia_office.create_user( [technician_role],
                  :email => "technician@gmail.com", 
                  :password => "willy1234",
                  :password_confirmation => "willy1234" ) # , :office_id => dikarunia_office.id
                  

machine_builder = dikarunia_office.create_user( [machine_builder_role],
                  :email => "machine_builder@gmail.com", 
                  :password => "willy1234",
                  :password_confirmation => "willy1234" ) # , :office_id => dikarunia_office.id

account_manager = dikarunia_office.create_user( [account_manager_role],
                    :email => "account_manager@gmail.com", 
                    :password => "willy1234",
                    :password_confirmation => "willy1234" ) # , :office_id => dikarunia_office.id

puts "category builder"
cooler_category = office.create_machine_category( "Cooler", machine_builder )  
fountain_category = office.create_machine_category( "Fountain", machine_builder )

puts "machine builder"
fountain_machine_1 = Machine.create(:model_name => "ML-150", fountain_category , machine_builder )
cooler_machine_1 = Machine.create(:model_name => "CIC-3001", cooler_category, machine_builder )


puts "component builder"
fountain_component_1 = fountain_machine_1.create_components( "Dry Hose 25cm", machine_builder ) 
fountain_component_2 = fountain_machine_1.create_components( "Dispenser Knob", machine_builder )
fountain_component_3 = fountain_machine_1.create_components( "CO2 Pressure Controller", machine_builder)

cooler_component_1 = cooler_machine_1.create_components( "Ozonized Fan", machine_builder ) 
cooler_component_2 = cooler_machine_1.create_components( "Temperature Controller", machine_builder )
cooler_component_3 = cooler_machine_1.create_components( "Freon Burner", machine_builder)


puts "component - create new spare part "

compatibility_fountain_1_1 = fountain_component_1.add_new_spare_part( {:part_code =>"MKC-3001", :price => 50 }, machine_builder )
compatibility_fountain_1_2 = fountain_component_1.add_new_spare_part( {:part_code =>"MKC-3001Z", :price => 4 }, machine_builder )
compatibility_fountain_2_1 = fountain_component_2.add_new_spare_part( {:part_code =>"KKC-8734", :price => 44 }, machine_builder )
compatibility_fountain_2_2 = fountain_component_2.add_new_spare_part( {:part_code =>"KKC-8735", :price => 3 }, machine_builder )

compatibility_cooler_1_1 = cooler_component_1.add_new_spare_part( {:part_code =>"MKC-3001" , :price => 9.5 }, machine_builder )
compatibility_cooler_1_2 = cooler_component_1.add_new_spare_part( {:part_code =>"MKC-3001Z", :price => 6 }, machine_builder )
compatibility_cooler_2_1 = cooler_component_2.add_new_spare_part( {:part_code =>"KKC-8734", :price => 4 }, machine_builder )
compatibility_cooler_2_2 = cooler_component_2.add_new_spare_part( {:part_code =>"KKC-8735", :price => 23 }, machine_builder )


puts "component - add compatibility to the existing sparepart"
existing_spare_part_1  = SparePart.create("MKC-734", machine_builder)
compatibility_fountain_1_1.assign_existing_spare_part( existing_spare_part_1, machine_builder )

puts "[PENDING] component - delete compatibility to the existing sparepart, not important for demo"
spare_part_fountain_1_1 = compatibility_fountain_1_1.spare_part
fountain_component_1.destroy_compatibility( spare_part_fountain_1_1 , machine_builder )

puts "we record the price history as well"
spare_part_fountain_1_1.change_price( 45.0  )

puts "after building the machine, create the Asset"
puts "Asset: machine + Asset Number + client_id. We need some sort of client builder"

puts "\n**************BUSINESS SETUP**************\n"

puts "Create client"
client_1 = dikarunia_office.create_client( "McDonald Cilincing" , account_manager)

puts "Create Asset"
asset_1 = cooler_machine_1.create_asset( account_manager, :client => client_1, :asset_no => "AXA2342")

puts "Create maintenance"
maintenance_1 = asset_1.create_maintenance!  # copying n components to n component statuses 

puts "Marking the component condition"
count = 0 
maintenance_1.component_statuses.each do |component_status|
  if count%0 == 1 
    component_status.mark_as_not_ok( data_entry) 
  else
    component_status.mark_as_ok( data_entry )
  end
  count += 1 
end  

invoice_1 = maintenance_1.produce_invoice!( data_entry ) # record the price id used. 

invoice_1.mark_as_paid!( cashier ) 

puts "******* THE WHOLE CYCLE is done! **********"












