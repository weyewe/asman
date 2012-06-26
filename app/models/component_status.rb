class ComponentStatus < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :maintenance
  belongs_to :component
  
  def mark_as_ok( employee) 
    if not employee.has_role?(:data_entry)
      return nil
    else
      mark_status( employee.id, true  )
    end
  end
  
  def mark_as_not_ok( employee) 
    if not employee.has_role?(:data_entry)
      return nil
    else
      mark_status( employee.id, false )
    end
  end

  def mark_status( creator_id , status_value) 
    self.creator_id = creator_id
    self.status = status_value 
    self.save
  end
  
end
