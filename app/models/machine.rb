class Machine < ActiveRecord::Base
  attr_accessible :model_name 
  belongs_to :machine_category 
  belongs_to :office
  
  has_many :components
  has_many :assets 
  
  def active_components
    self.components.where(:is_active => true )
  end
  
  
  
  def self.create_machine( params_model_name, machine_category, employee )
    if employee.nil? or not employee.has_role?(:machine_builder)
      return nil
    end
    
    if params_model_name.nil? or  params_model_name.length == 0 
      return nil
    end
    
    office = employee.active_job_attachment.office
    
    model_name = params_model_name.upcase
    # must be uniq in the office
    if office.has_machine_with_model_name?(model_name)
      return nil
    end
    
    
    machine = Machine.new(:model_name => model_name ) 
    machine.machine_category_id = machine_category.id 
    machine.creator_id = employee.id 
    machine.office_id = office.id 
    machine.save
    return machine 
  end
  
  def create_component( component_name , employee , component_category ) 
    if employee.nil? or not employee.has_role?(:machine_builder) or  component_category.nil? 
      return nil
    end
    
    if component_name.nil? or component_name.length == 0
      return nil
    end
    
    
    past_component = self.components.where(:name => component_name.upcase, :is_active => true ).first
    if not past_component.nil?
      return past_component
    end
    
    self.components.create(:name => component_name.upcase, 
      :creator_id => employee.id , 
      :component_category_id => component_category.id,
      :office_id => employee.active_job_attachment.office_id )
      
    
  end
  
  def create_asset( asset_no , client,  employee  )
    if not employee.has_role?(:account_manager)
      return nil
    end
    
    if asset_no.nil? or asset_no.length == 0 
      return nil
    end
    
    prev_asset = Asset.previous_asset(asset_no.upcase, client, self, employee )
    if not prev_asset.nil?
      return prev_asset
    else 
      return Asset.create(:asset_no => asset_no.upcase , :client_id => client.id, 
                  :machine_id => self.id, :creator_id => employee.id )
    end
    
  end
  
  
  def update_details(new_machine_model_name, employee)
    if not employee.has_role?(:machine_builder)
      return nil
    end
    
    if new_machine_model_name.nil? or new_machine_model_name.length == 0 
      return nil
    end
    
    employee_office= employee.active_job_attachment.office
    if self.office_id != employee_office.id
      return nil
    end
    
    if employee_office.has_machine_with_model_name?(new_machine_model_name)
      return nil
    end
    
    self.model_name = new_machine_model_name.upcase
    self.save
  end
  
  
  
end
