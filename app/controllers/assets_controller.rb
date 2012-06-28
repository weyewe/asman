class AssetsController < ApplicationController
  def new
    @client = Client.find_by_id params[:client_id]
    @assets = @client.assets 
    @new_asset = Asset.new 
  end
  
  
  def create
    @office = current_office
    @machine = Machine.find_by_id( params[:asset][:machine_id] )
    @client = Client.find_by_id params[:client_id]
    
    @new_asset = @machine.create_asset(params[:asset][:asset_no], @client , current_user )
    
    if not @new_asset.nil? and @new_asset.valid?
      flash[:notice] = "The component '#{@new_asset.asset_no}' has been created." 
      redirect_to new_client_asset_url(@client) 
      return 
    else
      @new_asset = Asset.new 
      flash[:error] = "Hey, do something better"
      render :file => "assets/new"
    end
  end
end
