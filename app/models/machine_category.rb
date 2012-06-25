class MachineCategory < ActiveRecord::Base
  # attr_accessible :title, :body
  
  belongs_to :office 
  has_many :machines
  
  def self.create_machine_category(name, machine_builder )
    office = machine_builder.active_job_attachment.office
    
    new_machine_category = MachineCategory.new
    new_machine_category.name = name
    new_machine_category.office_id = office.id
    new_machine_category.creator_id = machine_builder.id 
    new_machine_category.save
    return new_machine_category
  end
end
