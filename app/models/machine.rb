class Machine < ActiveRecord::Base
  attr_accessible :model_name 
  belongs_to :machine_category 
  belongs_to :office
  
  has_many :components
  has_many :assets 
  
  
  def self.create_machine( machine_hash, machine_category, machine_builder )
    office = machine_builder.active_job_attachment.office
    
    # must be uniq in the office
    if office.machines.where(:model_name => machine_hash[:model_name]).count != 0
      return nil
    end
    
    
    machine = Machine.create machine_hash 
    machine.machine_category_id = machine_category.id 
    machine.creator_id = machine_builder.id 
    machine.office_id = office.id 
    machine.save
    return machine 
  end
  
  def create_component( component_name , machine_builder ) 
    if machine_builder.nil?
      return nil
    end
    
    self.components.create(:name => component_name, :creator_id => machine_builder.id )
  end
  
  def create_asset( asset_no , client,  employee  )
    if not employee.has_role?(:account_manager)
      return nil
    end
    
    prev_asset = Asset.previous_asset(asset_no, client, self, employee )
    if not prev_asset.nil?
      return prev_asset
    else 
      return Asset.create(:asset_no => asset_no , :client_id => client.id, 
                  :machine_id => self.id, :creator_id => employee.id )
    end
    
  end
end
