class JobAttachment < ActiveRecord::Base
  attr_accessible :office_id, :user_id
  belongs_to :user
  belongs_to :office 
  
  has_many :assignments
  has_many :roles, :through => :assignments
  after_create :toggle_active_job_attachment_to_self
  
  
  def toggle_active_job_attachment_to_self
    user = self.user 
    user.job_attachments.each do |ja|
      if ja.id == self.id 
        ja.is_active = true 
      else
        ja.is_active = false
      end 
      ja.save
    end
  end
  
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end
  
  
end
