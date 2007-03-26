##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
module ParameterContextsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    ParameterContext.default_columns + 5 
  end
  
  def scaffold_columns
    ParameterContext.scaffold_columns
  end


##
# Dependent of the value change between concept selector and regex field
# 
  def adapt_row(row, value)
    found = "new Element.show('"+row+"[data_element_id]');new Element.hide('"+row+"[format_regex]');"
    not_found = "new Element.hide('"+row+"[data_element_id]');new Element.show('"+row+"[format_regex]');"
    jfunc = "if (value=="+value.to_s+") {"+found+"} else {"+not_found+"} "    
    return observe_field(row+"[data_type_id]",:function => jfunc )   
  end
  
  def parameter_bar(roles)
    out = String.new
    for role in roles
       out << link_to_function(subject_icon("#{role.name}.png"), " new Effect.toggle('role_"+role.id.to_s+"','slide')")
    end
    for role in roles
      for type in @types
       id = "type_" + type.id.to_s + "_" +role.id.to_s;
       out << "<span id ='type_" << type.id
       out << "_" << role.id
       out << "' class ='parameter_type'>"
       out << "<b>"+type.name+ "</b></span>"
       out <<  draggable_element( "type_#{type.id}_#{@role.id}" , :revert=> true) 
      end 
    end
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
  end
  
  def allowed_paramater_types(role)
     if (role.nil?)
        ParameterType.find(:all)
     else
        ParameterType.find_by_role(role)
     end
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
  end

###
#Build a role select element
#  
  def role_selector(roles)
    out = String.new
    hides = roles.collect{|a| "new Element.hide('tab-#{a.name}')"}
    out << '<div class="tabs">'
    out << '<ul class=tabs>'
    for role in roles  
      js = hides - ["new Element.hide('role-#{role.name}')"] + [" new Element.show('tab-#{role.name}')"] 
      out << '<li class="tab">'
      out <<  link_to_function("[#{role.name}]", js.join(";"))
      out << '</li>'
    end
    out << "</ul></div> \n"

    for role in roles 
      out << "<div class='tab-panel' id='tab-#{role.name}' "
      out << 'style="display: none;"' if role!=roles[0]
      out << "> \n" 
      out << role.description
      out << '<br/>'
      for type in allowed_paramater_types(role) 
        out << "<span id ='type_#{type.id}_#{role.id}' class ='parameter_type'>"
        out << "#{type.name} (#{role.name}) </span>"
        out <<  draggable_element( "type_#{type.id}_#{role.id}" , :revert=> true)
      end 
      out << "</div>"
    end 
    return out
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
  end
  
  
  def validate_text(field,regex)
     jfunc = 
     observe_field(field,:function => jfunc ) 
  end
  
  def validate(field,data_type,regex)
     
  end
end
