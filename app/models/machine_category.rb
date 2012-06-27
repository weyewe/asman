class MachineCategory < ActiveRecord::Base
  # attr_accessible :title, :body
  
  belongs_to :office 
  has_many :machines
  
  def self.create_machine_category(name, employee )
    if name.nil? or name.length ==0 
      return nil
    end
    
    if not employee.has_role?(:machine_builder)
      return nil
    end
    
    
    office = employee.active_job_attachment.office
    
    new_machine_category = MachineCategory.new
    new_machine_category.name = name
    new_machine_category.office_id = office.id
    new_machine_category.creator_id = employee.id 
    new_machine_category.save
    return new_machine_category
  end
  
  
  def machine_id_list
    Machine.where(:machine_category_id => self.id ).map{|x| x.id } 
  end
  
  def assets
    Asset.where(:machine_id => machine_id_list )
  end
end
