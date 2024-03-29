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
manager = dikarunia_office.create_main_user( [manager_role], 
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
cooler_category = MachineCategory.create_machine_category( "Cooler", machine_builder )  
fountain_category = MachineCategory.create_machine_category( "Fountain", machine_builder )

puts "machine builder"
fountain_machine_1 = Machine.create_machine(  "ML-150" , fountain_category , machine_builder )
cooler_machine_1 = Machine.create_machine(  "CIC-3001" , cooler_category, machine_builder )

puts "component category builder"
hose_comp_category  = ComponentCategory.create_component_category( "Hose", machine_builder)
dispenser_knob_comp_category = ComponentCategory.create_component_category( "Dispenser Knob", machine_builder)
controller_comp_category  = ComponentCategory.create_component_category("Controller", machine_builder)
fan_comp_category  = ComponentCategory.create_component_category("Fan", machine_builder)
burner_comp_category  = ComponentCategory.create_component_category("Burner", machine_builder)

puts "component builder"
fountain_component_1 = fountain_machine_1.create_component( "Dry Hose 25cm", machine_builder , hose_comp_category) 
fountain_component_2 = fountain_machine_1.create_component( "Dispenser Knob", machine_builder, dispenser_knob_comp_category )
fountain_component_3 = fountain_machine_1.create_component( "CO2 Pressure Controller", machine_builder, controller_comp_category)

cooler_component_1 = cooler_machine_1.create_component( "Ozonized Fan", machine_builder, fan_comp_category ) 
cooler_component_2 = cooler_machine_1.create_component( "Temperature Controller", machine_builder, controller_comp_category )
cooler_component_3 = cooler_machine_1.create_component( "Freon Burner", machine_builder, burner_comp_category)


puts "component - create new spare part "

spare_part_fountain_1_1 = fountain_component_1.add_new_spare_part( {:part_code =>"MKC-3001", :price => '50' }, machine_builder )
puts "after the spare part 1 "
spare_part_fountain_1_2 = fountain_component_1.add_new_spare_part( {:part_code =>"MKC-3001Z", :price => '4' }, machine_builder )
spare_part_fountain_2_1 = fountain_component_2.add_new_spare_part( {:part_code =>"KKC-8734", :price => '44' }, machine_builder )
spare_part_fountain_2_2 = fountain_component_2.add_new_spare_part( {:part_code =>"KKC-8735", :price => '3' }, machine_builder )

spare_part_cooler_1_1 =     cooler_component_1.add_new_spare_part( {:part_code =>"MKC-3001" , :price => '9.5' }, machine_builder )
spare_part_cooler_1_2 =     cooler_component_1.add_new_spare_part( {:part_code =>"MKC-3001Z", :price => '6' }, machine_builder )
spare_part_cooler_2_1 =     cooler_component_2.add_new_spare_part( {:part_code =>"KKC-8734", :price => '4' }, machine_builder )
spare_part_cooler_2_2 =     cooler_component_2.add_new_spare_part( {:part_code =>"KKC-8735", :price => '23' }, machine_builder )


puts "component - add compatibility to the existing sparepart"
existing_spare_part_1  = SparePart.create_new_spare_part({:part_code =>"MKC-38881" , :price => '9.5' }, machine_builder,  hose_comp_category)
if existing_spare_part_1.nil?
  puts "the spare_part_1 is nil"
else
  puts "it is not nil"
end
fountain_component_1.assign_existing_spare_part( existing_spare_part_1, machine_builder )
fountain_component_1.remove_existing_spare_part( existing_spare_part_1, machine_builder )

puts "[PENDING] component - delete compatibility to the existing sparepart, not important for demo"
# spare_part_fountain_1_1 = compatibility_fountain_1_1.spare_part
fountain_component_1.destroy_compatibility( spare_part_fountain_1_1 , machine_builder )

puts "we record the price history as well"
spare_part_fountain_1_1.change_price( '45.0' , machine_builder  )

puts "after building the machine, create the Asset"
puts "Asset: machine + Asset Number + client_id. We need some sort of client builder"

puts "\n**************BUSINESS SETUP**************\n"

puts "Create client"
client_1 = dikarunia_office.create_client( {:name => "McDonald Cilincing", :contact_person => "Roy Roy"} , account_manager)

puts "Create Asset"
asset_1 = cooler_machine_1.create_asset(  "AXA2342", client_1 , account_manager)

puts "Create maintenance"
work_order_no = "1234123"
maintenance_1 = asset_1.create_maintenance!( work_order_no, account_manager  ) # copying n components to n component statuses 

puts "Marking the component condition"
count = 0 
maintenance_1.component_statuses.each do |component_status|
  if count%2 == 1 
    component_status.mark_as_not_ok( data_entry) 
  else
    component_status.mark_as_ok( data_entry )
  end
  count += 1 
end  

puts "creating invoice"
# invoice is maintenance 
invoice_1 = maintenance_1.produce_invoice!( data_entry ) # record the price id used. 

puts "creating payment receipt"
invoice_1.mark_as_paid!( cashier ) 

puts "******* THE WHOLE CYCLE is done! **********"












