module PaginationHelper
  
  def pagination_links_full(paginator, options={}, html_options={})
    html = ''    
    html << link_to_remote(('&#171; ' + l(:label_previous)), 
                            {:update => "main", :url => { :page => paginator.current.previous }},
                            {:href => url_for(:action => 'list', :params => params.merge({:page => paginator.current.previous}))}) + ' ' if paginator.current.previous
                            
    html << (pagination_links_each(paginator, options) do |n|
      link_to_remote(n.to_s, 
                      {:url => {:action => 'list', :params => params.merge({:page => n})}, :update => 'content'},
                      {:href => url_for(:action => 'list', :params => params.merge({:page => n}))})
    end || '')
    
    html << ' ' + link_to_remote((l(:label_next) + ' &#187;'), 
                                 {:update => "main", :url => { :page => paginator.current.next }},
                                 {:href => url_for(:action => 'list', :params => params.merge({:page => paginator.current.next}))}) if paginator.current.next
    html  
  end
  
  
 def pagination_remote_links(paginator, options={}, html_options={})
     name   = options[:name]    || ActionController::Pagination::DEFAULT_OPTIONS[:name]
     params = (options[:params] || ActionController::Pagination::DEFAULT_OPTIONS[:params]).clone
     
     pagination_links_each(paginator, options) do |n|
       params[name] = n
       link_to_function n.to_s, "window.spotlight.search('#{n}')"
     end
  end
  
end
