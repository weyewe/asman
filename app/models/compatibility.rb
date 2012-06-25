class Compatibility < ActiveRecord::Base
  attr_accessible :component_id, :spare_part_id
  belongs_to :component
  belongs_to :spare_part 
end
