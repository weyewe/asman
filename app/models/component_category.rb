class ComponentCategory < ActiveRecord::Base
  attr_accessible :name, :creator_id , :office_id
  has_many :spare_parts
  has_many :components 
  belongs_to :office
  
  def active_components
    self.components.where(:is_active => true )
  end
  
  def active_spare_parts
    self.spare_parts.where(:is_active => true )
  end
  
  
  def self.create_component_category( component_category_name , employee)
    if not employee.has_role?(:machine_builder)
      return nil
    end
    
    
    if component_category_name.nil? or component_category_name.length ==0  
      return nil
    end
    
    past_component_category =  ComponentCategory.where(:name =>component_category_name.upcase ,
      :office_id =>employee.active_job_attachment.office_id  ).first 
    
    if not past_component_category.nil?
      return past_component_category
    end
    
    ComponentCategory.create(:name => component_category_name.upcase ,
      :creator_id => employee.id, 
      :office_id => employee.active_job_attachment.office_id )
  end
  
  def has_duplicate_component_category_in_the_office?( new_component_category_name, office  )
    ComponentCategory.where(:name =>new_component_category_name.upcase ,
      :office_id => office.id  ).length != 0 
  end
  
  def update_details(new_component_category_name, employee)
    if not employee.has_role?(:machine_builder)
      return nil
    end
    
    if new_component_category_name.nil? or new_component_category_name.length == 0 
      return nil
    end
    
    employee_office= employee.active_job_attachment.office
    if self.office_id != employee_office.id
      return nil
    end
    
    past_component_category =  ComponentCategory.where(:name =>new_component_category_name.upcase ,
      :office_id => employee_office.id  ).first 
    
    if not past_component_category.nil?
      return nil
    end
    
    self.name = new_component_category_name.upcase
    self.save
  end
  
  
end
