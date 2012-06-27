class SparePartsController < ApplicationController
  def new
    @component = Component.find_by_id params[:component_id]
    @machine = @component.machine 
  end
end
