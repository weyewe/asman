class MachineCategoriesController < ApplicationController
  def new
    @new_machine_category=  MachineCategory.new 
  end
  
  def create
    @office = current_office
    @new_machine_category = MachineCategory.create_machine_category(params[:machine_category][:name], current_user  )
    
    if not @new_machine_category.nil? and @new_machine_category.valid?
      flash[:notice] = "The machine category '#{@new_machine_category.name}' has been created." 
      redirect_to new_machine_category_url 
    else
      @new_machine_category = MachineCategory.new 
      flash[:error] = "Hey, do something better"
      render :file => "machine_categories/new"
    end
  end
  
=begin
  CREATE THE MACHINE
=end

  def select_machine_category_to_create_machine
    @machine_categories = current_office.machine_categories 
    
    render :file => "machine_categories/machines/select_machine_category_to_create_machine"
  end
end
