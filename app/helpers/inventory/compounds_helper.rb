
# Copyright � 2006 Robert Shell and Andrew Lemon, Alces Ltd All Rights Reserved

module Inventory::CompoundsHelper
###
# Hints
# 1) Too terminate a multiple line string the identifier like "END_OF_STATEMENT" must be the complete
# line with a return directly after if (White space hurts!)
# 
# 2) The Eval() method can be used to run string a piece on inline ruby code. So 
#    smiles = eval("@#{object}.#{method}") is a simple method to get the value from the passed in string
#    
# 3) Linked structure to text field on focus/blur to get/put structure from applet. This is needed
#    for the post of the form to pass values back to server   
###

##
#Smile Editor for  simple structure display in a table or report 
#  
#  Currently can only have 1 editor per page as name preset to MSketch
#  
def structure_edit_field(object,method)
  smiles = eval("@#{object}.#{method}")
  js = <<END_OF_STATEMENT
  var item = null;
  function init() {
	if(document.MSketch != null) {
	    item = documents.getElementByID("compound_smiles");
	    if(item!= null) item.value = document.MSketch.getMol('smiles');
		item = documents.getElementByID("compound_formula");
	    if(item!= null) item.value = document.MSketch.getMolFormula(); // not working yet
		item = documents.getElementByID("compound_mass");
		if(item!= null) item.value = document.MSketch.getMolFormula();
	} else {
		alert("no JavaScript to Java communication in your browser.");
	}
  }
 
  msketch_name = "MSketch";
  msketch_begin('/javascripts/marvin/', 400, 400);
  mview_param("background", "#ffffff");
  mview_param("molbg", "#ffffff");
  mview_param("mol", "#{smiles}" );
  msketch_end();  
END_OF_STATEMENT
  
  out = '<div class="ChemEditor">'
  out << javascript_tag(js)
  out << "<br />"
  out << text_field(object,method,:size=>60,:onSubmit=>"this.value = document.MSketch.getMol('smiles')", 
                                 :onfocus=>"this.value = document.MSketch.getMol('smiles')",
                                 :onChange=>"document.MSketch.setMol(this.value)")
  out << '</div>'
end


##
#Smile Viewer for  simple structure display in a table or report 
# 
# In this mode  the structure us unchangable as old value will
# away be returned in forms.
#  
def structure_view_field(object, method,width=500,hieght=300)
  smiles = eval("@#{object}.#{method}")
  js = <<END_OF_STATEMENT
  mview_mayscript = true;
  mview_name = "MView";
  mview_begin("/javascripts/marvin/", #{width}, #{hieght});
  mview_param("background", "#ffffff");
  mview_param("molbg", "#ffffff");
  mview_param("selectable", "false");
  mview_param("mol", "#{smiles}" );
  mview_end();
END_OF_STATEMENT

  out = '<div class="ChemEditor">'
  out << javascript_tag(js)
  out << hidden_field(object,method)
  out << '</div>'
end
## AL
#Mass field linked to structure editor
#  
#  Currently can only have 1 editor per page as name preset to MSketch
#  
def mass_field(object,method)
  smiles = eval("@#{object}.#{method}")
  out = '<div class="MassLinkedField">'
   out << text_field(object,method,:size=>10)
  out << '</div>'
end

## AL
#Formula field linked to structure editor
#  
#  Currently can only have 1 editor per page as name preset to MSketch
#  
def formula_field(object,method)
    smiles = eval("@#{object}.#{method}")
    out = '<div class="FormulaLinkedField">'
    out << text_field(object,method,:size=>30)
    out << '</div>'
end

## AL
#Make imagine of smiles
#  
#  
def smiles_depict_field(object, method)

    smiles = eval("@#{object}.#{method}")
    out = '<img src="<%= url_for :action => "image_for", :smiles => @smiles %>"></img>'
end

def chemistry_png(compound,x=100,y=100)
  filename = "#{compound.dom_id}_#{x}_#{y}.png"
  public_filename = 'public/images/compound/'+filename
  unless File.exists? public_filename
     filename =compound.to_png("#{compound.dom_id}_#{x}_#{y}.png",x,y)
     File.rename(filename, public_filename)
  end 
  if File.exists? public_filename
    return "<img src='/images/compound/#{filename}'></img>"
  else
    ""
  end
rescue Exception => ex
      logger.error "Failed to depict compound: #{compound.id}"  
      "#Cant Draw"      
end

end
