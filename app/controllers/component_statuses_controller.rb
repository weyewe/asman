class ComponentStatusesController < ApplicationController
  def mark_component_status
    
    @decision = params[:membership_decision].to_i
    @maintenance = Maintenance.find_by_id params[:membership_provider]
    @component_status = ComponentStatus.find_by_id params[:membership_consumer]
    
  
    if @decision == TRUE_CHECK
      @component_status.mark_as_ok( current_user )
    elsif @decision == FALSE_CHECK
      @component_status.mark_as_not_ok( current_user)
    end
    
    respond_to do |format|
      format.html {  redirect_to root_url }
      format.js
    end
  end
  
  def initial_component_status_marking
    @component_status = ComponentStatus.find_by_id params[:entity_id]
    @maintenance = @component_status.maintenance 
    
    @action_role = params[:action_role].to_i
    @action_value = params[:action_value].to_i

    if @action_role == APPROVER_ROLE
      if @action_value == TRUE_CHECK
        @component_status.mark_as_ok( current_user )
      elsif @action_value == FALSE_CHECK
        @component_status.mark_as_not_ok( current_user)
      end
    end

    respond_to do |format|
      format.html {  redirect_to root_url }
      format.js  
    end
  end
  
  def update
    @component_status = ComponentStatus.find_by_id(params[:id])
    spare_part = SparePart.find_by_id params[:component_status][:replacement_spare_part_id]
    @component_status.assign_replacement_spare_part(spare_part, current_user)
    @maintenance = @component_status.maintenance
  end
end
