module ApplicationHelper
  ACTIVE = 'active'
  REVISION_SELECTED = "selected"
  NEXT_BUTTON_TEXT = "Next &rarr;"
  PREV_BUTTON_TEXT = " &larr; Prev "
=begin
  For printing numbers (money)
=end

  def print_money(value)
    number_with_delimiter( value , :delimiter => ",")
  end
  
=begin
  Checkbox value 
=end

  def get_checkbox_value(checkbox_value )
    if checkbox_value == true
      return TRUE_CHECK
    else
      return FALSE_CHECK
    end
  end
  
=begin
  General command to create Guide in all pages
=end 
  def create_guide(title, description)
    result = ""
    result << "<div class='explanation-unit'>"
    result << "<h1>#{title}</h1>"
    result << "<p>#{description}</p>"
    result << "</div>"
  end

  def create_breadcrumb(breadcrumbs)

    if (  breadcrumbs.nil? ) || ( breadcrumbs.length ==  0) 
      # no breadcrumb. don't create 
    else
      breadcrumbs_result = ""
      breadcrumbs_result << "<ul class='breadcrumb'>"

      puts "After the first"


      breadcrumbs[0..-2].each do |txt, path|
        breadcrumbs_result  << create_breadcrumb_element(    link_to( txt, path ) ) 
      end 

      puts "After the loop"

      last_text = breadcrumbs.last.first
      last_path = breadcrumbs.last.last
      breadcrumbs_result << create_final_breadcrumb_element( link_to( last_text, last_path)  )
      breadcrumbs_result << "</ul>"
      return breadcrumbs_result
    end


  end

  def create_breadcrumb_element( link ) 
    element = ""
    element << "<li>"
    element << link
    element << "<span class='divider'>/</span>"
    element << "</li>"

    return element 
  end

  def create_final_breadcrumb_element( link )
    element = ""
    element << "<li class='active'>"
    element << link 
    element << "</li>"

    return element
  end
  
=begin
  Process Navigation related activity
=end  


  def get_process_nav( symbol, params)

    if symbol == :manager
      return create_process_nav(MANAGER_PROCESS_LIST, params )
    end

    if symbol == :machine_builder 
      return create_process_nav(MACHINE_BUILDER_PROCESS_LIST, params )
    end

    if symbol == :account_manager
      return create_process_nav(ACCOUNT_MANAGER_PROCESS_LIST, params )
    end

    if symbol == :cashier
      return create_process_nav(CASHIER_PROCESS_LIST, params )
    end

    if symbol == :data_entry
      return create_process_nav(DATA_ENTRY_PROCESS_LIST, params )
    end

    if symbol == :technician 
      return create_process_nav( TECHNICIAN_PROCESS_LIST, params )
    end

  end
  
  protected 
  
  #######################################################
  #####
  #####     Start of the process navigation code 
  #####
  #######################################################
   
  def create_process_nav( process_list, params )
    result = ""
    result << "<ul class='nav nav-list'>"
    result << "<li class='nav-header'>  "  + 
                 process_list[:header_title] + 
                 "</li>"         

    process_list[:processes].each do |process|
      result << create_process_entry( process, params )
    end

    result << "</ul>"

    return result
  end
   
   
  
  
  
  def create_process_entry( process, params )
    is_active = is_process_active?( process[:conditions], params)
    
    process_entry = ""
    process_entry << "<li class='#{is_active}'>" + 
                      link_to( process[:title] , extract_url( process[:destination_link] )    )
    
    return process_entry
  end
  
  def is_process_active?( active_conditions, params  )
    active_conditions.each do |condition|
      if condition[:controller] == params[:controller] &&
        condition[:action] == params[:action]
        return ACTIVE
      end

    end

    return ""
  end
  
  def extract_url( some_url )
    if some_url == '#'
      return '#'
    end
    
    eval( some_url ) 
  end
  
  
  MANAGER_PROCESS_LIST = {
    :header_title => "Manager",
    :processes => [
      {
        :title => "Create Employee",
        :destination_link => "root_url",
        :conditions => [
          {
            :controller => '',
            :action => ''
          },
          {
            :controller => "",
            :action => ''
          }
        ]
      },
      {
        :title => "Assign Role",
        :destination_link => "root_url",
        :conditions => [
          {
            :controller => '',
            :action => ''
          },
          {
            :controller => "",
            :action => ''
          }
        ]
      }
    ]
  }
  
  MACHINE_BUILDER_PROCESS_LIST = {
    :header_title => "Machine Builder",
    :processes => [
      {
        :title => "Machine Category",
        :destination_link => "new_machine_category_url",
        :conditions => [
          {
            :controller => 'machine_categories',
            :action => 'new'
          },
          {
            :controller => 'machine_categories',
            :action => 'create'
          }
        ]
      },
      {
        :title => "Machine",
        :destination_link => "select_machine_category_to_create_machine_url",
        :conditions => [
          {
            :controller => 'machine_categories',
            :action => 'select_machine_category_to_create_machine'
          },
          {
            :controller => "machines",
            :action => "new"
          },
          {
            :controller => "machines",
            :action => 'create'
          }
        ]
      },
      {
        :title => "Component Category",
        :destination_link => 'new_component_category_url',
        :conditions => [
          {
            :controller => 'component_categories',
            :action => 'new'
          },
          {
            :controller => "component_categories",
            :action => 'create'
          }
        ]
      },
      {
        :title => "Components",
        :destination_link => 'select_machine_to_create_component_url',
        :conditions => [
          {
            :controller => 'machines',
            :action => 'select_machine_to_create_component'
          },
          {
            :controller => "components",
            :action => 'new'
          },
          {
            :controller => 'components',
            :action => 'create'
          }
        ]
      },
      {
        :title => "Create + Assign Spare Part",
        :destination_link => "select_machine_to_create_and_assign_spare_part_url",
        :conditions => [
          {
            :controller => 'machines',
            :action => 'select_machine_to_create_and_assign_spare_part'
          },
          {
            :controller => "components", 
            :action => "select_component_to_create_and_assign_spare_part"
          },
          {
            :controller => "spare_parts",
            :action => "new"
          }
        ]
      }# ,
      #       {
      #         :title => "Compatibility",
      #         :destination_link => 'root_url',
      #         :conditions => [
      #           {
      #             :controller => '',
      #             :action => ''
      #           }
      #         ]
      #       }
    ]
  }
  
  ACCOUNT_MANAGER_PROCESS_LIST = {
    :header_title => "Machine Builder",
    :processes => [
      {
        :title => "Create Client",
        :destination_link => "new_client_url",
        :conditions => [
          {
            :controller => 'clients',
            :action => 'new'
          },
          {
            :controller => 'clients',
            :action => 'create'
          }
        ]
      },
      {
        :title => "Register  Asset",
        :destination_link => "select_client_to_create_asset_url",
        :conditions => [
          {
            :controller => 'clients',
            :action => 'select_client_to_create_asset'
          },
          {
            :controller => 'assets',
            :action => 'new'
          },
          {
            :controller => "assets",
            :action => "create"
          }
        ]
      }
    ]
  }
  
  CASHIER_PROCESS_LIST = {
    :header_title => "Machine Builder",
    :processes => [
      {
        :title => "Machine Category",
        :destination_link => "root_url",
        :conditions => [
          {
            :controller => '',
            :action => ''
          },
          {
            :controller => '',
            :action => ''
          }
        ]
      }
    ]
  }
  
  DATA_ENTRY_PROCESS_LIST = {
    :header_title => "Machine Builder",
    :processes => [
      {
        :title => "Machine Category",
        :destination_link => "root_url",
        :conditions => [
          {
            :controller => '',
            :action => ''
          },
          {
            :controller => '',
            :action => ''
          }
        ]
      }
    ]
  }
  
  TECHNICIAN_PROCESS_LIST = {
    :header_title => "Machine Builder",
    :processes => [
      {
        :title => "Machine Category",
        :destination_link => "root_url",
        :conditions => [
          {
            :controller => '',
            :action => ''
          },
          {
            :controller => '',
            :action => ''
          }
        ]
      }
    ]
  }
  
  
end
