class Component < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :spare_parts, :through => :compatibilities 
  has_many :compatibilities 
  
  # add_new_spare_part( {:part_code =>"MKC-3001", :price => 50 }, machine_builder )
  def add_new_spare_part(  spare_part_hash , machine_builder )
    if machine_builder.nil?
      return nil
    end
    
    office = machine_builder.active_job_attachment.office
    
    if  SparePart.pre_existing_in_office?(part_code, component, machine_builder) 
      return nil
    end
    
    spare_part = SparePart.create(:part_code => part_code , 
                  :office_id => office.id , 
                  :creator_id => machine_builder.id )
                  
    spare_part.create_price( spare_part_hash[:price] )
                  
    Compatibility.create(:spare_part_id => spare_part.id, :component_id => self.id)
    
    return spare_part 
  end
  

end
