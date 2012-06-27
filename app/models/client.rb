class Client < ActiveRecord::Base
  attr_accessible :name           ,
                  :contact_person ,
                  :phone_number   ,
                  :blackberry_pin ,
                  :email          ,
                  :address        ,
                  :creator_id 
                  
  validates :name, :presence => {:message => 'Name cannot be blank, Client not saved'}
  validates :contact_person, :presence => {:message => 'PIC cannot be blank, Client not saved'}
  
  belongs_to :office 
  has_many :maintenances 
  has_many :assets 
  
end
