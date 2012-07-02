class AssetsController < ApplicationController
  def new
    @client = Client.find_by_id params[:client_id]
    @assets = @client.assets 
    @new_asset = Asset.new 
    
    add_breadcrumb "Select Client", 'select_client_to_create_asset_url'
    set_breadcrumb_for @client, 'new_client_asset_url' + "(#{@client.id})", 
                "New Asset"
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
      
      add_breadcrumb "Select Client", 'select_client_to_create_asset_url'
      set_breadcrumb_for @client, 'new_client_asset_url' + "(#{@client.id})", 
                  "New Asset"
                  
      render :file => "assets/new"
    end
  end
  
  def select_asset_to_create_maintenance
    @client = Client.find_by_id params[:client_id]
    
    add_breadcrumb "Select Client", 'select_client_to_create_maintenance_url'
    set_breadcrumb_for @client, 'select_asset_to_create_maintenance_url' + "(#{@client.id})", 
                "Select Asset"
                
    render :file => "assets/maintenances/select_asset_to_create_maintenance"
    
  end
end
