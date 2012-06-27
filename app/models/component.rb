class Component < ActiveRecord::Base
  attr_accessible :name, :machine_id, :creator_id , :component_category_id 
  has_many :spare_parts, :through => :compatibilities 
  has_many :compatibilities 
  belongs_to :component_category
  
  # in the maintenance
  has_many :component_statuses 
  
  # add_new_spare_part( {:part_code =>"MKC-3001", :price => 50 }, machine_builder )
  def add_new_spare_part(  spare_part_hash , employee )
    if employee.nil? or not employee.has_role?(:machine_builder)
      return nil
    end
    
    office = employee.active_job_attachment.office
    
    if  SparePart.pre_existing_in_office?(spare_part_hash[:part_code],   employee) 
      return nil
    end
    
    spare_part = SparePart.create(:part_code => spare_part_hash[:part_code] , 
                  :office_id => office.id , 
                  :creator_id => employee.id ,
                  :component_category_id => self.component_category_id )
                  
    spare_part.create_price( spare_part_hash[:price] , employee )
                  
    return Compatibility.create(:spare_part_id => spare_part.id, :component_id => self.id)
    
     
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
    
    
    past_existing_spare_part= self.spare_parts.where(:id => existing_spare_part.id ).first 
    
    if not past_existing_spare_part.nil?
      if past_existing_spare_part.component_category_id != self.component_category_id 
        return nil
      end
      
      if not self.has_compatibility?(past_existing_spare_part )
        self.create_compatibility( past_existing_spare_part )
      end
      
      return past_existing_spare_part
    else
      return nil
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
end
