class Office < ActiveRecord::Base
  attr_accessible :name
  has_many :machine_categories 
  has_many :machines
  has_many :spare_parts
  has_many :clients
  has_many :component_categories 
  
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
  
end
