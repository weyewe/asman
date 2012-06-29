class ComponentStatus < ActiveRecord::Base
  attr_accessible :maintenance_id , :component_id 
  belongs_to :maintenance
  belongs_to :component
  
  def mark_as_ok( employee) 
    if self.maintenance.is_finalized == true
      return nil
    end
    
    if not employee.has_role?(:data_entry)
      return nil
    else
      mark_status( employee.id, true  )
    end
  end
  
  def mark_as_not_ok( employee) 
    if self.maintenance.is_finalized == true
      return nil
    end
    
    if not employee.has_role?(:data_entry)
      return nil
    else
      mark_status( employee.id, false )
    end
  end

  def mark_status( creator_id , status_value) 
    self.creator_id = creator_id
    self.status = status_value 
    
    if status_value == false 
      self.replacement_spare_part_id = nil 
    end
    
    self.save
  end
  
  
  def compatible_spare_parts
    spare_parts  = self.component.active_spare_parts
    result = []
    spare_parts.each do |spare_part|
          result << [ "#{spare_part.part_code}" , 
                          spare_part.id ]
    end
    return result
  end
  
  def replacement_spare_part
    SparePart.find_by_id self.replacement_spare_part_id
  end
  
  def assign_replacement_spare_part(spare_part, employee)
    if not employee.has_role?(:data_entry)
      return nil
    end
    
    if not self.component.has_compatibility?(spare_part)
      return nil
    end
    
    self.replacement_spare_part_id = spare_part.id 
    self.save
  end
end
