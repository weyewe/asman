class ComponentsController < ApplicationController
  
  def new
    @machine = Machine.find_by_id params[:machine_id]
    @new_component = Component.new 
  end
end
