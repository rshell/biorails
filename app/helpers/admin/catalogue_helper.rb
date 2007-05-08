module Admin::CatalogueHelper
  
  include Alces::TreeControl
##
# Convert the catalogue into a sett
# 
  def tree_for_catalog( context)
      logger.info "tree_for_catalog(#{context.name})"
      tree= Alces::TreeControl::Node.create(context) do |node,rec|
         node.link = link_to_remote rec.name, :url => catalogue_url(:action=>:show,:id=>rec)
         node.name = nil
         node.drop_url = nil
      end    
      tree.link = link_to_remote context.name, :url => catalogue_url(:action=>:show,:id=>context)         
      out = ""
      out << "<div id='#{context.dom_id(:tree)}' class='dtree'>"
      out << node_html(tree, 0 ,true)
      out << '</div>'
      return out
  rescue Exception => ex
      logger.error "error: #{ex.message}"
      logger.error ex.backtrace.join("\n")    
      return "Failed in tree_for_catalog"
   end


end
