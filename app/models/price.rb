class Price < ActiveRecord::Base
  # attr_accessible :title, :body
  
  after_create :toggle_active_price
  
  
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
  
  
end
