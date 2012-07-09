class MaintenancesController < ApplicationController
  def new_maintenance_for_asset
    @asset = Asset.find_by_id params[:asset_id] 
    @client = @asset.client
    @machine = @asset.machine 
    
    @new_maintenance = Maintenance.new
    
    add_breadcrumb "Select Client", 'select_client_to_create_maintenance_url'
    set_breadcrumb_for @client, 'select_asset_to_create_maintenance_url' + "(#{@client.id})", 
                "Select Asset"
    set_breadcrumb_for @asset, 'new_maintenance_for_asset_url' + "(#{@asset.id})", 
                "New Asset"
    
  end
  
  def create_maintenance_for_asset
    @asset = Asset.find_by_id( params[:asset_id] )
    @new_maintenance = @asset.create_maintenance!( params[:maintenance][:work_order_no], current_user  )
    @client = @asset.client
    @machine = @asset.machine
    
    if not @new_maintenance.nil? and @new_maintenance.valid?
      flash[:notice] = "The maintenance '#{@new_maintenance.work_order_no}' has been created." 
      redirect_to new_maintenance_for_asset_url(@asset) 
      return 
    else
      @new_maintenance = Maintenance.new 
      flash[:error] = []
      if Maintenance.is_uniq?(params[:maintenance][:work_order_no], @asset) == false
        flash[:error] << "Work Order is not Unique" + "<br />"
      end
      
      if params[:maintenance][:work_order_no].nil? or params[:maintenance][:work_order_no].length == 0 
        flash[:error] << "Must Enter Work Order" + "<br />"
      end
      
      if @asset.has_unfinalized_past_maintenances?
        flash[:error] << "Unfinalized Past Asset Maintenance"
      end
      
      
      add_breadcrumb "Select Client", 'select_client_to_create_maintenance_url'
      set_breadcrumb_for @client, 'select_asset_to_create_maintenance_url' + "(#{@client.id})", 
                  "Select Asset"
      set_breadcrumb_for @asset, 'new_maintenance_for_asset_url' + "(#{@asset.id})", 
                  "New Asset"
                  
      render :file => "maintenances/new_maintenance_for_asset"
    end
  end
  
  
  def select_unfinalized_maintenance_to_be_done
    render :file => "maintenances/component_statuses/select_unfinalized_maintenance_to_be_done"
  end
  
  def component_status_data_entry_for_maintenance
    @maintenance = Maintenance.find_by_id( params[:maintenance_id] ) 
    @asset = @maintenance.asset
    @machine = @asset.machine
    @client = @asset.client 
    @component_statuses= @maintenance.component_statuses.includes(:component).order("created_at ASC")
    
    add_breadcrumb "Select Maintenace", 'select_unfinalized_maintenance_to_be_done_url'
    set_breadcrumb_for @maintenance, 'component_status_data_entry_for_maintenance_url' + "(#{@maintenance.id})", 
                "Maintenance"
                
                
    render :file => "maintenances/component_statuses/component_status_data_entry_for_maintenance"
  end
  
  def finalize_maintenance
    @maintenance = Maintenance.find_by_id(params[:maintenance_id])
    @maintenance.produce_invoice!( current_user  ) 
    
    if @maintenance.is_finalized == true 
      flash[:notice] = "Maintenance Finalization is successful. Please wait for the invoice creation"
    else
      flash[:error] = []
    end
    
    redirect_to component_status_data_entry_for_maintenance_url(@maintenance)
  end
  
  def view_broken_and_replaced_item
    @maintenance = Maintenance.find_by_id(params[:maintenance_id])
    @asset = @maintenance.asset
    @machine = @asset.machine
    @client = @asset.client 
    
    add_breadcrumb "Select Client", 'select_client_to_create_maintenance_url'
    set_breadcrumb_for @client, 'select_asset_to_create_maintenance_url' + "(#{@client.id})", 
                "Select Asset"
    set_breadcrumb_for @asset, 'new_maintenance_for_asset_url' + "(#{@asset.id})", 
                "New Asset"
    set_breadcrumb_for @maintenance, 'view_broken_and_replaced_item_url' + "(#{@maintenance.id})", 
                "Maintenance Result"

                
  end
  
end
