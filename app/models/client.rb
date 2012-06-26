class Client < ActiveRecord::Base
  attr_accessible :name           ,
                  :contact_person ,
                  :phone_number   ,
                  :blackberry_pin ,
                  :email          ,
                  :address        ,
                  :creator_id 
  
  belongs_to :office 
  has_many :maintenances 
  has_many :assets 
  
end
