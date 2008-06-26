##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 
module Project::ProjectsHelper
  #
  # Modified version of render which overides the directory with the passed root
  #
  def project_render(options = {}, old_local_assigns = {}, &block)
      if options.is_a?(String)
        render_file(options, true, old_local_assigns)
        
      elsif options == :update
        update_page(&block)
        
      elsif options.is_a?(Hash)
        
        if options[:layout]
          path, partial_name = partial_pieces(options.delete(:layout))
          if block_given?
            @content_for_layout = capture(&block)
            concat(render(options.merge(:partial => "#{path}/#{partial_name}")), block.binding)
          else
            @content_for_layout = render(options)
            render(options.merge(:partial => "#{path}/#{partial_name}"))
          end
          
        elsif options[:action]
          path = Project.current.action_template(options[:partial])
          render_file(path, true, options[:locals])

        elsif options[:file]
          render_file(options[:file], options[:use_full_path], options[:locals])
          
        elsif options[:partial] && options[:collection]
          path = Project.current.partial_template(options[:partial])          
          render_partial_collection(path, options[:collection], options[:spacer_template], options[:locals])
          
        elsif options[:partial]
          path = Project.current.partial_template(options[:partial])
          render_partial(path, ActionView::Base::ObjectWrapper.new(options[:object]), options[:locals])
          
        elsif options[:inline]
          render_template(options[:type], options[:inline], nil, options[:locals])
        end
      end
  end    
end
