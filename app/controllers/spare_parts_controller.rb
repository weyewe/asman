class SparePartsController < ApplicationController
  def new
    @component = Component.find_by_id params[:component_id]
    @new_spare_part = SparePart.new
    
    @machine = @component.machine 
    
    add_breadcrumb "Select Machine", 'select_machine_to_create_and_assign_spare_part_url'
    set_breadcrumb_for @machine, 'select_component_to_create_and_assign_spare_part_url' + "(#{@machine.id})", 
                "Select Component"
                
    set_breadcrumb_for @component, 'new_component_spare_part_url' + "(#{@component.id})", 
                "Select Component"
  end
  
  def create
    @component= Component.find_by_id params[:component_id]
    @machine = @component.machine 
    @new_spare_part = @component.add_new_spare_part( {:part_code => params[:spare_part][:part_code],  
              :price => params[:price] }, 
          current_user )
    
    if not @new_spare_part.nil? and @new_spare_part.valid?
      flash[:notice] = "The component '#{@new_spare_part.part_code}' has been created." 
      redirect_to new_component_spare_part_url(@component)
      return 
    else
      @new_spare_part = SparePart.new 
      flash[:error] = []
      
      if SparePart.pre_existing_in_office?(params[:spare_part][:part_code].upcase, current_user) 
        flash[:error] << "There has been spare part with part code: #{params[:spare_part][:part_code].upcase}" + "<br />"
      end
      
      if params[:spare_part][:part_code].nil? or params[:spare_part][:part_code].length ==0 
        flash[:error] << "Please fill in the part code" + "<br />"
      end
      
      if params[:price].nil? or params[:price].length == 0
        flash[:error] << "Please fill in the price "
      end
      
      if Price.valid_price_string?(params[:price] )
        flash[:error] << "Invalid Price. Must be >= 0 "
      end
      
      
      add_breadcrumb "Select Machine", 'select_machine_to_create_and_assign_spare_part_url'
      set_breadcrumb_for @machine, 'select_component_to_create_and_assign_spare_part_url' + "(#{@machine.id})", 
                  "Select Component"

      set_breadcrumb_for @component, 'new_component_spare_part_url' + "(#{@component.id})", 
                  "Select Component"
                  
                  
      render :file => "spare_parts/new"
    end
  end
  
  
  def update
    @component = Component.find_by_id params[:component_id]
    @spare_part = SparePart.find_by_id params[:id]
    
    @price = params[:price]
    @part_code = params[:part_code]
    
    @initial_price = @spare_part.active_price.amount
    @initial_part_code = @spare_part.part_code 
    
    @result = @spare_part.update_details(@part_code, @price, current_user)
    
  end
end
