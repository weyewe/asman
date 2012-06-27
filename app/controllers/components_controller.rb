class ComponentsController < ApplicationController
  
  def new
    @machine = Machine.find_by_id params[:machine_id]
    @new_component = Component.new 
  end
  
  def create
    @office = current_office
    @component_category = ComponentCategory.find_by_id( params[:component][:component_category_id] )
    @machine  = Machine.find_by_id params[:machine_id]
    
    @new_component = @machine.create_component(params[:component][:name], current_user , @component_category )
    
    if not @new_component.nil? and @new_component.valid?
      flash[:notice] = "The component '#{@new_component.name}' has been created." 
      redirect_to new_machine_component_url(@machine) 
      return 
    else
      @new_component = Component.new 
      flash[:error] = "Hey, do something better"
      render :file => "components/new"
    end
  end
  
=begin
  Creating spare part
=end
  def select_component_to_create_and_assign_spare_part
    @machine = Machine.find_by_id params[:machine_id]
    @components = @machine.components 
    render :file => 'components/spare_parts/select_component_to_create_and_assign_spare_part'
  end
end
