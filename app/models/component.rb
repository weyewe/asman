class Component < ActiveRecord::Base
  attr_accessible :name, :machine_id, :creator_id , :component_category_id , :office_id 
  has_many :spare_parts, :through => :compatibilities 
  has_many :compatibilities 
  belongs_to :component_category
  
  # in the maintenance
  has_many :component_statuses 
  belongs_to :machine
  
  after_create :update_non_finalized_maintenances 
  
  def active_spare_parts
    self.spare_parts.where(:is_active => true )
  end
  # add_new_spare_part( {:part_code =>"MKC-3001", :price => 50 }, machine_builder )
  def add_new_spare_part(  spare_part_hash , employee )
    if employee.nil? or not employee.has_role?(:machine_builder)
      return nil
    end
    
    spare_part_part_code = spare_part_hash[:part_code].upcase
    spare_part_price = spare_part_hash[:price]
    
    if spare_part_price.nil? or spare_part_price.length == 0  or not Price.valid_price_string?(spare_part_price)
      return nil
    end
    
    spare_part_price = Price.parse_price( spare_part_price )
    
    
    office = employee.active_job_attachment.office
    
    if spare_part_part_code.nil? or spare_part_part_code.length == 0
      return nil
    end
    
    if  SparePart.pre_existing_in_office?(spare_part_part_code,   employee) 
      return nil
    end
    
    spare_part = SparePart.create(:part_code => spare_part_part_code, 
                  :office_id => office.id , 
                  :creator_id => employee.id ,
                  :component_category_id => self.component_category_id )
                  
    spare_part.create_price( spare_part_price , employee )
                  
    Compatibility.create(:spare_part_id => spare_part.id, :component_id => self.id)
    
    return spare_part 
  end
  
  
  def create_compatibility(spare_part)
    self.compatibilities.create(:spare_part_id => spare_part.id )
  end
  
  def has_compatibility?(spare_part)
    not Compatibility.where(:component_id => self.id, :spare_part_id => spare_part.id ).first.nil?
  end
  
  
  def assign_existing_spare_part( existing_spare_part , employee )
    if not employee.has_role?(:machine_builder)
      return nil
    end
    
    
    past_existing_spare_part= SparePart.find_by_id(existing_spare_part.id)
    
    if not past_existing_spare_part.nil?
      if past_existing_spare_part.component_category_id != self.component_category_id 
        puts "There is past existing spare_part"
        return nil
      end
      
      if not self.has_compatibility?(past_existing_spare_part )
        self.create_compatibility( past_existing_spare_part )
      end
      
      return past_existing_spare_part
    else
      puts "not NIL"
      return nil
    end
  end
  
  def remove_existing_spare_part( existing_spare_part, employee ) 
    if not employee.has_role?(:machine_builder)
      return nil
    end
    
    compatibilities = Compatibility.where(:spare_part_id => existing_spare_part.id, :component_id => self.id)
    
    if not compatibilities.length == 0 
      compatibilities.each {|x| x.destroy }
    end
  end
  
  
  def destroy_compatibility( spare_part , employee)
    if employee.nil? or not employee.has_role?(:machine_builder)
      return nil
    end
    
    compatibilities = Compatibility.where(:spare_part_id => spare_part.id , :component_id => self.id )
    compatibilities.each do |compatibility|
      compatibility.destroy 
    end
  end
  
  
  def is_compatible_with?(spare_part)
    Compatibility.where(:component_id => self.id , :spare_part_id => spare_part.id).count != 0
  end
  
  def update_non_finalized_maintenances
    Maintenance.where(:is_finalized => false, :machine_id => self.machine_id  ).each do |maintenance|
      maintenance.component_statuses.create(:component_id => self.id )
    end
  end
  

  def has_duplicate_component_name_for_the_same_machine?( new_component_name )
    self.machine.components.where(:name => new_component_name.upcase, :is_active => true ).length != 0 
  end
  
  def update_details( component_name, employee) 
    if not employee.has_role?(:machine_builder )
      return nil
    end
    
    employee_office= employee.active_job_attachment.office
    if self.office_id != employee_office.id
      return nil
    end
    
    if component_name.nil? or component_name.length == 0 
      return nil
    end
    
    past_component = self.machine.components.where(:name => component_name.upcase, :is_active => true ).first
    if not past_component.nil?
      return nil
    end
    
    self.name = component_name.upcase
    self.save 
  end
  
  
  def deactivate(employee)
    if not employee.has_role?(:machine_builder)
      return nil
    end
    
    employee_office = employee.active_job_attachment.office
    if self.office_id != employee_office.id 
      return nil
    end
    
    if self.is_active == false 
      return nil
    end
    
    self.is_active = false 
    self.destroyer_id = employee.id 
    self.save 
    
    #  get all those maintenances 
    employee_office.pending_execution_maintenances.where(:machine_id => self.machine_id).each do |pending_maintenance|
      pending_maintenance.component_statuses.where(:component_id => self.id).each do |component_status|
        component_status.destroy
      end
    end
    
    # get those compatibilities 
    self.compatibilities.each do |compatibility|
      compatibility.destroy 
    end
  end
  
end
