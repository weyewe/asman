class Office < ActiveRecord::Base
  attr_accessible :name
  has_many :machine_categories 
  has_many :machines
  has_many :spare_parts
  has_many :clients
  
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
  
  
  def create_client( client_name  , employee)
    if not employee.has_role?(:account_manager )
      return nil
    end
    
    self.clients.create :name => client_name , :creator_id => employee.id 
    
  end
  
end
