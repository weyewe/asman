class Role < ActiveRecord::Base
  attr_accessible :name  #, :body
  has_many :assignments
  has_many :job_attachments, :through => :assignments
end
