class SparePart < ActiveRecord::Base
  attr_accessible :component_id , :part_code , :office_id , :creator_id , :component_category_id
  has_many :compatibilities 
  has_many :components, :through => :compatibilities 
  belongs_to :component_category 
  belongs_to :office 
  has_many :prices 
  
  
  def self.create_new_spare_part( data_hash , machine_builder , component_category )
    if  SparePart.pre_existing_in_office?(data_hash[:part_code],  machine_builder) 
      return nil
    end
    
    if component_category.nil?
      return nil
    end
    
    if machine_builder.nil?
      return nil
    end
    
    office = machine_builder.active_job_attachment.office
    
    spare_part = SparePart.create(:part_code => data_hash[:part_code] , 
                  :office_id => office.id , 
                  :creator_id => machine_builder.id ,
                  :component_category_id => component_category.id )
    if data_hash[:price].nil?
      spare_part.prices.create(:amount =>  BigDecimal( "0" ))
    else
      spare_part.prices.create(:amount =>  BigDecimal( data_hash[:price] ) )
    end
    
      
    return spare_part 
  end
  
  
  def SparePart.pre_existing_in_office?(part_code, employee) 
    office = employee.active_job_attachment.office
    office.active_spare_parts.where(:part_code => part_code, :is_active => true   ).count != 0 
  end
  
  #price amount is in BigDecimal 
  def create_price(price_amount, employee ) 
    if price_amount.nil?
      return nil
    end
    
    self.prices.create(:amount => price_amount, :creator_id => employee.id )
  end
  
  # the price is in BigDecimal 
  def change_price(price_amount , employee )
    if price_amount.nil?
      return nil
    end
    self.prices.create( :amount => price_amount , :creator_id => employee.id )
  end
  
  def active_price
    self.prices.where(:is_active => true ).first
  end
  
  def update_details( part_code, price, employee)
    if part_code.nil? or price.nil? or employee.nil?
      return nil
    end
    
    if part_code.length == 0 
      return nil
    end
    
    price_string = price.gsub(",", '')
    part_code = part_code.upcase 
    if not  Price.valid_price_string?(price_string)
      return nil
    end
    
    #  can't take other part's part code 
    if SparePart.pre_existing_in_office?(part_code, employee) and self.part_code != part_code 
      return nil
    end
    
    self.part_code = part_code
    self.save
    
    self.change_price( Price.parse_price( price_string ), employee )
    
    return self 
  end
end
