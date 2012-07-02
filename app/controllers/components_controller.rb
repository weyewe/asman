class ComponentsController < ApplicationController
  
  def new
    @machine = Machine.find_by_id params[:machine_id]
    @new_component = Component.new 
    
    add_breadcrumb "Select Machine", 'select_machine_to_create_component_url'
    set_breadcrumb_for @machine, 'new_machine_component_url' + "(#{@machine.id})", 
                "New Component"
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
    
    add_breadcrumb "Select Machine", 'select_machine_to_create_component_url'
    set_breadcrumb_for @machine, 'new_machine_component_url' + "(#{@machine.id})", 
                "New Component"
  end
  
=begin
  Creating spare part
=end
  def select_component_to_create_and_assign_spare_part
    @machine = Machine.find_by_id params[:machine_id]
    @components = @machine.components 
    
    add_breadcrumb "Select Machine", 'select_machine_to_create_and_assign_spare_part_url'
    set_breadcrumb_for @machine, 'select_component_to_create_and_assign_spare_part_url' + "(#{@machine.id})", 
                "Select Component"
                
    render :file => 'components/spare_parts/select_component_to_create_and_assign_spare_part'
  end
end
