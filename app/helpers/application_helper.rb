##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def logged_in?
    !session[:user_id].nil?
  end
 
###
# Simple boolean switch for display of a div 
# 
  def display(ok)
    if ok
     ''
    else
     'style="display: none;"'
    end
  end
#
# Customer version of error_messages display
#
  def error_messages_for(*params)
     options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}
     objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
     count   = objects.inject(0) {|sum, object| sum + object.errors.count }
     unless count.zero?
           html = {}
           [:id, :class].each do |key|
             if options.include?(key)
               value = options[key]
               html[key] = value unless value.blank?
             else
               html[key] = 'errorExplanation'
             end
           end
           header_message = "Errors prohibited this [#{(options[:object_name] || params.first).to_s.gsub('_', ' ')}] from being saved"
           error_messages = objects.map {|object| object.errors.full_messages.uniq.map {|msg| content_tag(:li, msg) } }
           content_tag(:div,
             content_tag(options[:header_tag] || :h4, header_message) <<
               content_tag(:p, 'There were problems with the following fields:') <<
               content_tag(:ol, error_messages),
             html
           )
     else
           ''
     end
  end
  
#
# Test what the client browser is 
#  
  def browser_is? name
    name = name.to_s.strip
    return true if browser_name == name
    return true if name == 'mozilla' && browser_name == 'gecko'
    return true if name == 'ie' && browser_name.index('ie')
    return true if name == 'webkit' && browser_name == 'safari'
  end
#
# Get the Browser Name
#
  def browser_name
    @browser_name ||= begin
      ua = request.env['HTTP_USER_AGENT'].downcase
      if ua.index('msie') && !ua.index('opera') && !ua.index('webtv')
        'ie'+ua[ua.index('msie')+5].chr
      elsif ua.index('gecko/') 
        'gecko'
      elsif ua.index('opera')
        'opera'
      elsif ua.index('konqueror') 
        'konqueror'
      elsif ua.index('applewebkit/')
        'safari'
      elsif ua.index('mozilla/')
        'gecko'
      end
    end
  end
#
# Generate a Json description of a model 
# with optional initial data set
#
   def model_to_json(clazz, data = nil)
    fields =[]
    filters=[]
    columns=[]
    clazz.columns.each do  |column|
       field = {:name=> column.name  }
       cview =  { :header => column.human_name, 
                   :width=> 70, 
                   :sortable=> true, 
                   :dataIndex => column.name  }
                 
       filter = {:dataIndex => column.name }
       case column.type 
       when :integer
           field[:type]=:int
           filter[:type]=:numeric
       when :float
           field[:type]=:float
           filter[:type]=:numeric
       else      
           filter[:type]=:string
       end
       fields <<  field
       filters << filter
       columns << cview
    end
    
    item = {:id => "#{clazz.table_name}-grid",
            :model => clazz.to_s, 
            :controller => clazz.table_name,
            :fields => fields,
            :filters => filters,
            :columns=> columns}
    if (data)
      item[:data]=data.collect{|i|i.attributes}
    end      
    return item.to_json    
 end

 #
 # Update the the content of the main  panel
 # 
 def main_panel(*options_for_render)
   call 'Element.update','center', render(*options_for_render)   
 end
 #
 # Update the the content of the help panel
 # 
 def help_panel(*options_for_render)
   call 'Element.update','help', render(*options_for_render)   
 end
 #
 # Update the the content of the work area panel
 # 
 def work_panel(*options_for_render)
   call 'Element.update','work', render(*options_for_render)   
 end
 #
 # Update the the content of the status panel
 # 
 def status_panel(*options_for_render)
   call 'Element.update','status', render(*options_for_render)  
 end
 #
 # Update the the content of the audit panel
 # 
 def audit_panel(*options_for_render)
   call 'Element.update','audit', render(*options_for_render)
 end
 #
 # Update the the content to new tab on the center panel
 # 
 def add_tab(id,*options_for_render )
   assign(:content, brender(*options_for_render)   )  
   page<<  "Biorails.addTab(#{id},content);"
 end
#
# Create a datagrid
#
  def model_datagrid(clazz,data=nil)
#   assign(:my_grid, model_to_json(clazz,data) )  
   page<< "Biorails.showGrid( #{model_to_json(clazz,data)});"
 end
 
  def show_folder(folder)	
	page<< "Ext.onReady(Biorails.folder( #{folder.id} ,'Folder #{folder.path}'),Biorails);"
  end
#
# Update the menu actions
#
 def actions_panel(*options_for_render)
   call 'Element.update','actions', render(*options_for_render)
 end
#
# Update the tree panel
#
 def tree_panel(*options_for_render)
   call 'Element.update','tree', render(*options_for_render)
 end
#
# Generate items for top menu structure
#
  def home_items
     @items = [
       {:href=>home_url(:id=>User.current.id),:text=>'home'},
       {:href=>home_url(:action=>'calendar',:id=>User.current.id),:text=>'Schedule'},
       {:href=>home_url(:action=>'projects',:id=>User.current.id),:text=>'Projects'}       
     ]
  end  

  def inventory_items
     @items = [
       {:href=>compound_url(:action=>'list'),:text=>'Compounds'},
       {:href=>batch_url(:action=>'list'),:text=>'Batches'},
       {:href=>plate_url(:action=>'list'),:text=>'Plates'},
       {:href=>container_url(:action=>'list'),:text=>'Samples'},
       {:href=>treatment_group_url(:action=>'list'),:text=>'Treatment Groups'},
       {:href=>specimen_url(:action=>'list'),:text=>'Specimens'}
     ]
  end  

  def admin_items
     @items = [
       {:href=>home_url(:id=>User.current.id),:text=>'home'},
       {:href=>catalogue_url(:action=>'list'),:text=>'Catalogue'},
       {:href=>data_type_url(:action=>'list'),:text=>'Data Types'},       
       {:href=>data_format_url(:action=>'list'),:text=>'Data Formats'},       
       {:href=>parameter_type_url(:action=>'list'),:text=>'Parameter Types'},       
       {:href=>parameter_role_url(:action=>'list'),:text=>'Parameter Roles'},       
       {:href=>study_stage_url(:action=>'list'),:text=>'Study Stages'},       
       {:href=>user_url(:action=>'list'),:text=>'User'},       
       {:href=>role_url(:action=>'list'),:text=>'Roles'},       
       {:href=>data_system_url(:action=>'list'),:text=>'Systems'}       
     ]
  end  

  def project_items
    @items = User.current.projects.collect do |project|
      {:href=>project_url(:action=>'show',:id=>project),:text=>project.name}
    end
  end  

end
