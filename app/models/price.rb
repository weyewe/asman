class Price < ActiveRecord::Base
  attr_accessible :amount, :creator_id , :spare_part_id 
  
  after_create :toggle_active_price
  belongs_to :spare_part 
  
  
  def toggle_active_price
    spare_part = self.spare_part 
    spare_part.prices.each do |ja|
      if ja.id == self.id 
        ja.is_active = true 
      else
        ja.is_active = false
      end 
      ja.save
    end
    self.creator_id = spare_part.creator_id 
    self.save 
  end
  
  
  def self.valid_price_string?(price_string)
    not self.parse_price(price_string).nil? 
    
    parsed_price = self.parse_price(price_string)
    if parsed_price.nil?
      return false
    else
      return true 
    end
  end
  
  def self.parse_price(price_string )
    begin
      Float(price_string)
    rescue
      return nil 
    end
    zero_value = BigDecimal("0")
    price = BigDecimal(price_string)
    
    if price >= zero_value 
      return price
    else
      return nil
    end
    

  end
  
end
