class ComponentCategory < ActiveRecord::Base
  attr_accessible :name, :creator_id , :office_id
  has_many :spare_parts
  has_many :components 
  belongs_to :office
  
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
end
