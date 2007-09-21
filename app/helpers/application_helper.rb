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
##
#Setup tabs for form
#
 def tab_setup(tab_ids,tab_names)
    out = String.new
    out = <<EOS
<script type="text/javascript" >
   function switchid(id){ $('#{tab_ids.join("','")}').invoke('hide'); Element.show(id); }
</script>
EOS
   return out
 end

##
# Generate a header for a tab
# 
# * tab_ids     array of div id for tabs
# * tab_names   array of tab names
# * tab_no      integer number of the tab in the array
# * current     integer number of the current tab
# 
# "javascript:switchid('<%= div_ids[i] %>');"
    
# 
 def tab_divide(tab_ids, tab_names, tab_no=0, current=0)
    out = String.new
    out << "<div id='#{tab_ids[tab_no]}' "
    if tab_no==current
      out << "style='display:block;'>" 
    else 
      out << "style='display:none;'> "
    end 
    out << '<br/>'
    out << '<ul class="tablist">'
    for i in 0 ... tab_ids.length do
        if tab_no == i
           out << "<li> <a class='current' " 
        else 
           out << "<li> <a " 
        end  
        out << 'href="javascript:switchid('
        out << "'" << tab_ids[i]
        out << "');"<< '"' << ">  #{tab_names[i]}  </a>"
        out << '</li>'
    end 
    out << '</ul>'
    return out
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
  
  
  def browser_is? name
    name = name.to_s.strip
    return true if browser_name == name
    return true if name == 'mozilla' && browser_name == 'gecko'
    return true if name == 'ie' && browser_name.index('ie')
    return true if name == 'webkit' && browser_name == 'safari'
  end

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

def setup_toolbar(div_name = 'top-toolbar')
  script = <<JS
MainMenu = function(){
    var toolbar;

return {	
    init : function(){
       toolbar = new Ext.Toolbar('#{div_name}');

       toolbar.addButton({
               cls: 'x-btn-text-icon bmenu', 
  	       text:'Home',
               menu: new Ext.menu.Menu({
                             id: 'menuHome',
                             items: #{home_items.to_json} })
                         });

       toolbar.addButton({
               cls: 'x-btn-text-icon bmenu', 
  	       text:'Project [#{current_project.name}]',
               menu: new Ext.menu.Menu({
                             id: 'menuProject',
                             items: #{project_items.to_json} })
                         });

       toolbar.addButton({
               cls: 'x-btn-text-icon bmenu', 
  	       text:'Administration',
               menu: new Ext.menu.Menu({
                             id: 'menuAdmin',
                             items: #{admin_items.to_json} })
                         });
    
       toolbar.addFill();

       toolbar.addField(
                   new Ext.form.TextField({
                    fieldLabel: 'search',
                    name: 'first',
                    width:175,
                    allowBlank:false
                }));
       toolbar.addButton({text: 'search'})          
       }
     };       
}();


Ext.EventManager.onDocumentReady(MainMenu.init, MainMenu, true);
 
JS
  javascript_tag(script)
end  

protected 
  def home_items
     @items = [
       {:href=>home_url(:id=>User.current.id),:text=>'home'},
       {:href=>home_url(:action=>'calendar',:id=>User.current.id),:text=>'Schedule'},
       {:href=>home_url(:action=>'projects',:id=>User.current.id),:text=>'Projects'}       
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
