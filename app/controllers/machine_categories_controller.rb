class MachineCategoriesController < ApplicationController
  def new
    @new_machine_category=  MachineCategory.new 
  end
  
  def create
    
    redirect_to new_machine_category_url
  end
end
