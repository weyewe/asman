class ComponentCategoriesController < ApplicationController
  
  def new
    @new_component_category=  ComponentCategory.new 
  end
  
  def create
    @office = current_office
    @new_component_category = ComponentCategory.create_component_category(params[:component_category][:name], current_user  )
    
    if not @new_component_category.nil? and @new_component_category.valid?
      flash[:notice] = "The machine category '#{@new_component_category.name}' has been created." 
      redirect_to new_component_category_url 
    else
      @new_component_category = ComponentCategory.new 
      flash[:error] = "Hey, do something better"
      render :file => "component_categories/new"
    end
  end
  
  def select_component_category_to_create_spare_part
    @component_categories = current_office.component_categories 
    render :file => "component_categories/spare_parts/select_component_category_to_create_spare_part"
  end
  
  def update
    @component_category = ComponentCategory.find_by_id params[:id]
    @new_component_category_name = params[:new_component_category_name]
    @result = @component_category.update_details( @new_component_category_name, current_user)
  end
end
