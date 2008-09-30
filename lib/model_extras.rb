# 
# This library contains various inhancements to Models
#  * to/form dom_id
#  * to_html via liquid templates
#  * to_ext_json for data grids
# 
module ModelExtras  
  
  VERSION='0.2.0'
  
  # Context a node to objects
  # 
  # This is used for convertopn of dom_id to the correct object
  # 
  def self.from_dom_id(node)
    case node
      when ActiveRecord::Base 
      node
      when Symbol 
      node.to_s
      when String
      id = node.to_s.split('_').last 
      case node
        when /team_[0-9]+/            then Team.find(id)
        when /report_column_[0-9]+/   then ReportColumn.find(id)
        when /report_[0-9]+/          then Report.find(id)
        when /team_[0-9]+/            then Team.find(id)
        when /project_[0-9]+/         then Project.find(id)
        when /assay_[0-9]+/           then Assay.find(id)
        when /assay_protocol_[0-9]+/ , /assay_process_[0-9]+/ , /assay_workflow_[0-9]+/  
        AssayProtocol.find(id)
        when /assay_parameter_[0-9]+/ 
        AssayParameter.find(id)
        when /protocol_version_[0-9]+/ ,  /process_instance_[0-9]+/ , /process_flow_[0-9]+/ 
        ProtocolVersion.find(id)
        when /parameter_type_[0-9]+/  then ParameterType.find(id)
        when /parameter_role_[0-9]+/  then ParameterRole.find(id)
        when /parameter_context_[0-9]+/ then ParameterContext.find(id)
        when /parameter_[0-9]+/       then Parameter.find(id)
        when /experimnent_[0-9]+/     then Experiment.find(id)
        when /task_[0-9]+/            then Task.find(id)
        when /user_[0-9]+/            then User.find(id)
      else
        node.to_s
      end  
    end
  end
  # ## Implementation of
  # http://codefluency.com/articles/2006/05/30/rails-views-dom-id-scheme
  # 
  #  comment.dom_id
  #  => "comment_15"
  # 
  # Use in views and controllers instead of doing "comment_<%= comment.id %>"
  # 
  # 
  def dom_id(prefix=nil)
    display_id = new_record? ? "new" : id
    prefix = prefix.nil? ? self.class.class_name.underscore : "#{prefix}_#{self.class.class_name.underscore}"
    "#{prefix}_#{display_id}"
  end

  def my_methods
    (self.methods - self.class.superclass.methods).sort
  end
  # 
  # Default Active Record to_liquid object conversion
  # 
  def to_liquid
    self.attributes.stringify_keys
  end
  
  def to_html_cached?
    (respond_to?(:project_element) and respond_to?(:updated_at)  and project_element and 
        (project_element.content and self.updated_at <= project_element.content.updated_at))
  end
  # 
  # Generate html view for the model based on liquid templates For presentation
  # in reports
  # 
  def to_html(cache =true)
    return project_element.content.body_html if (cache and to_html_cached?)
         
    name = self.class.class_name.underscore
    full_path = File.join(RAILS_ROOT,"app","views","models","#{name}.liquid")
   
    if File.exists?(full_path)
      template = File.read(full_path)
      html_text = Liquid::Template.parse(template).render({ 'record'=> self, name=> self })
      if respond_to?(:project_element) and cache and project_element
         project_element.update_content(html_text)
         project_element.save               
      end
      return html_text
    else        
      "No such template '#{full_path}'"
    end
  rescue  Exception => ex
    logger.debug ex.backtrace.join("\n") 
    logger.error ex.message
  end
  
  
end
