class SparePart < ActiveRecord::Base
  attr_accessible :component_id , :part_code , :office_id , :creator_id 
  has_many :compatibilities 
  has_many :components, :through => :compatibilities 
  
  has_many :prices 
  
  
  def self.create_new_spare_part( part_code, machine_builder )
    if  SparePart.pre_existing_in_office?(part_code, component, machine_builder) 
      return nil
    end
    
    if machine_builder.nil?
      return nil
    end
    
    office = machine_builder.active_job_attachment.office
    
    spare_part = SparePart.create(:part_code => part_code , 
                  :office_id => office.id , 
                  :creator_id => machine_builder.id )
      
  end
  
  
  def SparePart.pre_existing_in_office?(part_code, component, machine_builder) 
    office = machine_builder.active_job_attachment.office
    office.spare_parts.where(:part_code => part_code  ).count != 0 
  end
  
  def create_price(price) 
    price_amount = BigDecimal(price )
    
    self.prices.create(:amount => price_amount)
  end
end
