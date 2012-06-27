class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  layout :layout_by_resource
  helper_method :current_office 
  
  def layout_by_resource
    if devise_controller? && resource_name == :user && action_name == 'new'
      "devise"
    else
      "application"
    end
  end
  
  def current_office
    if @office.nil?
      if current_user.nil?
        return nil
      end
    
      @office = current_user.active_job_attachment.office
    end
    
    return @office
  end
  
  
  def after_sign_in_path_for(resource)
    active_job_attachment  = current_user.active_job_attachment 
    if current_user.has_role?( :manager )
      puts "user has role branch_manager!\n"*10
      return new_group_loan_product_url
    end
    
    if current_user.has_role?(:machine_builder )
      puts "user has role loan_officer!\n"*10
      return new_machine_category_url  
    end
    
    if current_user.has_role?(:account_manager )
      puts "user has role loan_officer!\n"*10
      return new_client_url  
    end
   
    
  end
  
  
  def set_breadcrumb_for object, destination_path, opening_words
    # puts "THIS IS WILLLLLY\n"*10
    # puts destination_path
    add_breadcrumb "#{opening_words}", destination_path
  end

  protected
  def add_breadcrumb name, url = ''
    @breadcrumbs ||= []
    url = eval(url) if url =~ /_path|_url|@/
    @breadcrumbs << [name, url]
  end

  def self.add_breadcrumb name, url, options = {}
    before_filter options do |controller|
      controller.send(:add_breadcrumb, name, url)
    end
  end
end
