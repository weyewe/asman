require 'valid_email'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  has_many :offices, :through => :job_attachments 
  has_many :job_attachments
  
  validates :email, :presence => true, :email => true
  
  def active_job_attachment
    self.job_attachments.where(:is_active => true).first
  end
  
  def has_role?(role_sym)
    active_job_attachment.has_role?(role_sym)
  end
  
  def valid_role_updating_info?(office, employee)
    if not employee.has_role?(:manager)
      return false
    end
    
    job_attachment = JobAttachment.find(:first, :conditions => {
      :office_id =>office.id,
      :user_id => self.id
    })
    # is the executing employee is in the same office with the employee being executed?
    if employee.active_job_attachment.office_id != job_attachment.office_id 
      return false
    end
    
    return true
  end
  
  def add_role( role, office, employee)
    if not valid_role_updating_info?(office, employee)
      return nil
    end
    
    job_attachment = JobAttachment.find(:first, :conditions => {
      :office_id =>office.id,
      :user_id => self.id
    })
    
    if job_attachment.roles.map{|x| x.id}.include?(role.id)
      return nil
    else
      # create the role assignment 
      Assignment.create(:job_attachment_id => job_attachment.id, 
      :role_id => role.id )
    end
  end
  
  def remove_role(role, office, employee)
    if not valid_role_updating_info?(office, employee)
      puts "not valid role updating info"
      return nil
    end
    
    job_attachment = JobAttachment.find(:first, :conditions => {
      :office_id =>office.id,
      :user_id => self.id
    })
    
    if job_attachment.roles.map{|x| x.id}.include?(role.id)
      if self.id == office.main_user_id && role.id == Role.find_by_name(USER_ROLE[:manager]).id
        puts "has the role id , but it is the main user"
        return nil
      end
      # destroy the role assignment 
      assignments = Assignment.find(:all, :conditions => {
        :role_id => role.id,
        :job_attachment_id => job_attachment.id 
      })
      assignments.each do |assignment|
        assignment.destroy
      end
      
    else
      puts "there is no mentioned role id"
      return nil
    end
    
  end
  
end
