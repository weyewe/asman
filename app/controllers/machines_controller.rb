class MachinesController < ApplicationController
  def new
    @machine_category = MachineCategory.find_by_id( params[:machine_category_id] )
    @new_machine = Machine.new 
  end
  
 
  
  def create
    @office = current_office
    @machine_category = MachineCategory.find_by_id( params[:machine_category_id] )
    
    @new_machine = Machine.create_machine(params[:machine][:model_name], @machine_category , current_user  )
    
    if not @new_machine.nil? and @new_machine.valid?
      flash[:notice] = "The machine category '#{@new_machine.model_name}' has been created." 
      redirect_to new_machine_category_machine_url(@machine_category) 
      return 
    else
      @new_machine = Machine.new 
      flash[:error] = "Hey, do something better"
      render :file => "machines/new"
    end
  end
  
=begin
  CREATING THE COMPONENT FOR MACHINE
=end

  def select_machine_to_create_component
    @machines = current_office.machines.order("machine_category_id ASC")
    
    render :file => "machines/components/select_machine_to_create_component"
  end
  
  
=begin
  CREATING AND ASSIGNING SPARE_PART to MACHINE COMPONENT
=end
  def select_machine_to_create_and_assign_spare_part
    @machines = current_office.machines 
    render :file => "machines/spare_parts/select_machine_to_create_and_assign_spare_part"
  end
end


