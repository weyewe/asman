class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  layout :layout_by_resource
  helper_method :current_office , :deduce_after_sign_in_url
  
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
  
  
  def deduce_after_sign_in_url
    if current_user.has_role?( :manager )
      return new_employee_creation_url
    end
    
    if current_user.has_role?(:machine_builder )
      return new_machine_category_url  
    end
    
    if current_user.has_role?(:account_manager )
      return new_client_url  
    end
    
    if current_user.has_role?(:data_entry )
      return select_unfinalized_maintenance_to_be_done_url  
    end
  end
  
  def after_sign_in_path_for(resource)
    return deduce_after_sign_in_url 
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
