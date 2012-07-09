class Maintenance < ActiveRecord::Base
  attr_accessible :work_order_no, :asset_id , :creator_id , :office_id, :machine_id
  has_many :component_statuses 
  belongs_to :asset 
  after_create :create_component_statuses
  belongs_to :office
  #  what is the logic to maintain the uniqness? 
  # from a given client, only 1 work order no
  def self.is_uniq?(work_order_no, asset)
    Maintenance.where(:work_order_no => work_order_no.upcase, :asset_id => asset.id ).count == 0 
  end
  
  def create_component_statuses
    self.asset.machine.components.each do |component|
      ComponentStatus.create :maintenance_id => self.id, :component_id => component.id 
    end
  end
  
  def any_component_not_marked?
    self.component_statuses.where(:status => nil).count != 0 
  end
  
  def any_broken_component_not_replaced?
    self.component_statuses.where(:status => false, :replacement_spare_part_id => nil ).count != 0 
  end
  
  
  
  def produce_invoice!( employee ) 
    if not employee.has_role?(:data_entry )
      return nil 
    end
    
    if self.is_finalized == true 
      return self
    end
    
    if any_component_not_marked?
      return self
    end
    
    if any_broken_component_not_replaced?
      return self
    end
    
    self.is_finalized = true
    self.finalizer_id = employee.id
    self.finalization_datetime = DateTime.now 
    self.save 
    # self.delay.create_maintenance_invoice # and send email 
    return self
  end
  
  
  def mark_as_paid!( employee ) 
    if not employee.has_role?(:cashier )
      return nil 
    end
    
    if self.is_paid == true 
      return self
    end
    
    if self.is_finalized == false
      return nil
    end
    
    self.is_paid = true
    self.payment_approver_id = employee.id
    self.payment_datetime = DateTime.now 
    self.save   
    # self.delay.create_payment_receipt  # and send email 
    return self 
  end
  
  def self.all_maintenances(client)
    Maintenance.where(  :asset_id => client.asset_id_list )
  end
  
  def self.completed_maintenances(client)
    Maintenance.where(:is_finalized => true, :asset_id => client.asset_id_list )
  end
  
  def self.paid_maintenances(client)
    Maintenance.where(:is_paid => true, :is_finalized => true, :asset_id => client.asset_id_list )
  end
  
  def self.in_progress_maintenances(client)
    Maintenance.where(:is_paid => false, :is_finalized => false, :asset_id => client.asset_id_list )
  end
  
  def broken_components
    self.component_statuses.where(:status => false )
  end
  
end
