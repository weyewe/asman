class Maintenance < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :component_statuses 
  belongs_to :asset 
  after_create :create_component_statuses
  
  
  def self.is_uniq?(work_order_no, asset)
    Maintenance.where(:work_order_no => work_order_no, :asset_id => asset.id ).count == 0 
  end
  
  def create_component_statuses
    self.asset.machine.components.each do |component|
      ComponentStatus.create :maintenance_id => self.id, :component_id => component.id 
    end
  end
  
  
  def produce_invoice!( employee ) 
    if not employee.has_role?(:data_entry )
      return nil 
    end
    
    if self.is_finalized == true 
      return self
    end
    
    self.is_finalized = true
    self.finalizer_id = employee.id
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
    
    self.is_paid = true
    self.payment_approver_id = employee.id
    self.save   
    # self.delay.create_payment_receipt  # and send email 
    return self 
  end
  
end
