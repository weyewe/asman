class OfficesController < ApplicationController
  def new_employee_creation
    @new_employee = User.new 
    @employees = current_office.users
  end
  
  def create_employee
    @new_employee = current_office.create_employee_by_email( params[:user][:email])
    
    if not @new_employee.nil? and @new_employee.valid?
      flash[:notice] = "The employee '#{@new_employee.email}' has been created." 
      redirect_to new_employee_creation_url
      return 
    else
      @employees = current_office.users
      @new_employee = User.new 
      flash[:error] = []
      if params[:user][:email].nil? or params[:user][:email].length == 0 
        flash[:error] << "Email has to be present"
      end
      
      if User.find_by_email(params[:user][:email]).nil?
        flash[:error] << "There is duplicate email"
      end
        
      render :file => "offices/new_employee_creation"
    end
  end
  
  def show_role_for_employee
    @employee = User.find_by_id params[:employee_id]
    @roles = Role.find(:all, :order => "created_at DESC")
  end
  
  def assign_role_for_employee
    @decision = params[:membership_decision].to_i
    @role = Role.find_by_id params[:membership_provider]
    @employee = User.find_by_id params[:membership_consumer]
    @office = current_office
  
    if @decision == TRUE_CHECK
      @employee.add_role(@role, @office, current_user)
      # @component.assign_existing_spare_part( @spare_part , current_user )
    elsif @decision == FALSE_CHECK
      @employee.remove_role(@role, @office,current_user)
      # @component.remove_existing_spare_part( @spare_part, current_user )
    end
    
    respond_to do |format|
      format.html {  redirect_to root_url }
      format.js
    end
  end
end
