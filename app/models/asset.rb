class Asset < ActiveRecord::Base
  attr_accessible :asset_no,:client_id , :machine_id, :creator_id 
  
  belongs_to :machine 
  belongs_to :client
  has_many :maintenances 
  
  def create_maintenance!( work_order_no ,employee )
    if not employee.has_role?(:account_manager)
      return nil
    end
    client = self.client 
    if not Maintenance.is_uniq?(work_order_no, self)
      return nil
    else
      return Maintenance.create(:work_order_no => work_order_no, :asset_id => self.id, :creator_id => employee.id  )
    end
  end
  
  def self.previous_asset(asset_no, client, machine, employee )
    Asset.where(:asset_no => asset_no, :client_id => client.id,  :creator_id => employee.id ).first 
  end
end
