class ClientsController < ApplicationController
  def new
    @new_client = Client.new
  end
  
  def create
    if not current_user.has_role?(:account_manager)
      redirect_to root_url
      return
    end
    
    @office = current_office
    @new_client = Client.new( params[:client] )
    @new_client.creator_id = current_user.id 
    @new_client.office_id = current_office.id
    
    if @new_client.save 
      flash[:notice] = "The client category '#{@new_client.name}' has been created." 
      redirect_to new_client_url 
    else
      flash[:error] = "Hey, do something better"
      render :file => "clients/new"
    end
  end
  
  def select_client_to_create_asset
    render :file => "clients/assets/select_client_to_create_asset"
  end
  
  
end
