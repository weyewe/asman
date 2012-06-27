class CompatibilitiesController < ApplicationController
  
  def create
    @decision = params[:membership_decision].to_i
    @component = Component.find_by_id params[:membership_provider]
    @spare_part = SparePart.find_by_id params[:membership_consumer]
    
  
    if @decision == TRUE_CHECK
      @component.assign_existing_spare_part( @spare_part , current_user )
    elsif @decision == FALSE_CHECK
      @component.remove_existing_spare_part( @spare_part, current_user )
    end
    
    respond_to do |format|
      format.html {  redirect_to root_url }
      format.js
    end
  end
end

