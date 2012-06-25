class Machine < ActiveRecord::Base
  attr_accessible :model_name 
  belongs_to :machine_category 
  
  has_many :components
  
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
end
