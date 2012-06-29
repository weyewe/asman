class Asset < ActiveRecord::Base
  attr_accessible :asset_no,:client_id , :machine_id, :creator_id 
  
  belongs_to :machine 
  belongs_to :client
  has_many :maintenances 
  
  def create_maintenance!( work_order_no ,employee )
    if not employee.has_role?(:account_manager)
      return nil
    end
    
    if work_order_no.nil? or work_order_no.length == 0 
      return nil
    end
  
    if has_unfinalized_past_maintenances?
      return nil
    end 
    
    client = self.client 
    if not Maintenance.is_uniq?(work_order_no, self)
      return nil
    else
      return Maintenance.create(:work_order_no => work_order_no, :asset_id => self.id, :creator_id => employee.id,
      :office_id => employee.active_job_attachment.office_id , :machine_id => self.machine_id )
    end
  end
  
  def self.previous_asset(asset_no, client, machine, employee )
    Asset.where(:asset_no => asset_no, :client_id => client.id,  :creator_id => employee.id ).first 
  end
  
  
  def unfinalized_past_maintenances
    self.maintenances.where(:is_finalized => false )
  end
  
  def has_unfinalized_past_maintenances?
    unfinalized_past_maintenances.count != 0 
  end
end
