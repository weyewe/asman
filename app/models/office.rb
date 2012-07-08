class Office < ActiveRecord::Base
  attr_accessible :name
  has_many :machine_categories 
  has_many :machines
  has_many :spare_parts
  has_many :clients
  has_many :component_categories 
  has_many :maintenances
  
  has_many :users, :through => :job_attachments 
  has_many :job_attachments
  
=begin
  CREATING USER
=end
  def create_employee_by_email( email )
    user = User.create :email => email, :password => 'willy1234', 
      :password_confirmation => 'willy1234'
      
    if not user.valid? 
      return nil
    else
      JobAttachment.create(:office_id => self.id, :user_id => user.id)
      return user 
    end
    
    
  end

  def users
    User.joins(:job_attachments).where(
    :job_attachments => {
      :is_deleted => false,
      :office_id => self.id
    })
  end
   
  def active_spare_parts
    self.spare_parts.where(:is_active => true )
  end
  
  def main_user
    User.find_by_id self.main_user_id
  end
  
  def create_main_user(role_list, user_hash) 
    user = self.create_user(role_list, user_hash)
    self.main_user_id = user.id 
    self.save
  end
  
  def create_user(role_list, user_hash)
    new_user = User.new(user_hash)
    
    if not new_user.save
      return nil
    end
    
    job_attachment = JobAttachment.create(:user_id => new_user.id, :office_id => self.id)
    
    role_list.each do |role|
      Assignment.create_role_assignment_if_not_exists( role,  new_user)
    end
    
    return new_user 
    
  end
  
  
  def create_client( client_hash  , employee)
    if not employee.has_role?(:account_manager )
      return nil
    end
    
    self.clients.create( :name => client_hash[:name] , 
                :contact_person=> client_hash[:contact_person], 
                :creator_id => employee.id)
  end
  
  def all_component_categories
    component_categories  = self.component_categories
    result = []
    component_categories.each do |component_category|
          result << [ "#{component_category.name}" , 
                          component_category.id ]
    end
    return result
  end
  
  def all_machines
    machines  = self.machines
    result = []
    machines.each do |machine|
          result << [ "#{machine.machine_category.name} (  Model: #{machine.model_name}  )" , 
                          machine.id ]
    end
    return result
  end
  
 
  
  def pending_execution_maintenances
    self.maintenances.where(:is_finalized => false )
  end
  
  def has_machine_with_model_name?(model_name)
    if model_name.nil? or model_name.length == 0 
      return false
    end
    self.machines.where(:model_name => model_name.upcase ).count > 0 
  end
  
end
