class Asset < ActiveRecord::Base
  # attr_accessible :title, :body
  
  belongs_to :client
  has_many :maintenances 
  
  def create_maintenance!( work_order_no ,employee )
    if not employee.has_role?(:account_manager)
      return nil
    end
    client = self.client 
    if not Maintenance.is_uniq?(work_order_no, asset)
      return nil
    else
      return Maintenance.create(:work_order_no => work_order_no, :asset_id => asset.id, :creator_id => employee.id  )
    end
  end
end
