# SelectAutocompleter
module SelectAutocompleterMacroHelper
	  
	  # Simililar to Autocompleter functionality except it
	  # pops up a listbox instead of a list; Adds autocomplete to the text input field with the 
      # DOM ID specified by +field_id+.
      #
      # This function expects that the called action returns an HTML <select> element,
      # or nothing if no entries should be displayed for autocompletion.
      #
      # You'll probably want to turn the browser's built-in autocompletion off,
      # so be sure to include an <tt>autocomplete="off"</tt> attribute with your text
      # input field.
      #
      # The autocompleter object is assigned to a Javascript variable named <tt>field_id</tt>_auto_completer.
      # This object is useful if you for example want to trigger the auto-complete suggestions through
      # other means than user input (for that specific case, call the <tt>activate</tt> method on that object). 
      # 
      # Required +options+ are:
      # <tt>:url</tt>::                  URL to call for autocompletion results
      #                                  in url_for format.
      # 
      # Additional +options+ to the ones of autocompleter are:
      # <tt>:value_element</tt>::        The id of a text or hidden field to receive the value
      #                                  corresponding to to the selection
      # <tt>:redirect_url</tt>::        URL where the page will be redirected upon selection
      #                                  in url_for format.
      #                                  the string '??' in the URL will be replace by the value
      #                                  corresponding to to the selection 
      # <tt>:row_count</tt>::           The number of rows in the select element.
      # <tt>:use_cache</tt>::           Cache the result on the client side.
  def select_auto_complete_field(field_id, options = {})
    function =  "var #{field_id}_select_auto_completer = new Ajax.SelectAutocompleter("
    function << "'#{field_id}', "
    function << "'" + (options[:update] || "#{field_id}_select_auto_complete") + "', "
    function << "'#{url_for(options[:url])}'"
    
    js_options = {}
    js_options[:tokens] = array_or_string_for_javascript(options[:tokens]) if options[:tokens]
    js_options[:callback]   = "function(element, value) { return #{options[:with]} }" if options[:with]
    js_options[:indicator]  = "'#{options[:indicator]}'" if options[:indicator]
    js_options[:select]     = "'#{options[:select]}'" if options[:select]
    js_options[:paramName]  = "'#{options[:param_name]}'" if options[:param_name]
    js_options[:frequency]  = "#{options[:frequency]}" if options[:frequency]
    js_options[:valueElement]  = "'#{options[:value_element]}'" if options[:value_element]
    js_options[:rowCount]  = "#{options[:row_count]}" if options[:row_count]
    js_options[:useCache]  = options[:use_cache] == false ? false : true
    js_options[:redirect_url]  = "'#{url_for(options[:redirect_url])}'" if options[:redirect_url]

    { :after_update_element => :afterUpdateElement, 
      :on_show => :onShow, :on_hide => :onHide, :min_chars => :minChars }.each do |k,v|
      js_options[v] = options[k] if options[k]
    end

    function << (', ' + options_for_javascript(js_options) + ')')

    javascript_tag(function)
  end
  
        # Use this method in your view to generate a return for the AJAX autocomplete requests.
        #
        # Example action:
        #
        #   def auto_complete_for_item_title
        #     @items = Item.find(:all, 
        #       :conditions => [ 'LOWER(description) LIKE ?', 
        #       '%' + request.raw_post.downcase + '%' ])
        #     render :inline => "<%= select_auto_complete_result(@items, 'description', id) %>"
        #   end
        #
        # The select_auto_complete_result can of course also be called from a view belonging to the 
        # auto_complete action if you need to decorate it further.
    def select_auto_complete_result(entries, field, idField = "id", phrase = nil)
      return unless entries
      items = entries.map { |entry| content_tag("option", phrase ? highlight(entry[field], phrase) : h(entry[field]),
      :value => entry[idField]) }
      content_tag("select", items.uniq)
    end
  
        # Wrapper for text_field with added AJAX selectAutocompletion functionality.
        #
        # In your controller, you'll need to define an action called
        # select_auto_complete_for_object_method to respond the AJAX calls,
        # 
        # See the RDoc on ActionController::AutoComplete to learn more about this.
  def  combo_box_auto_complete(object, method, tag_options = {}, completion_options = {})
    text_field(object, method, tag_options) +
    content_tag("div", "", :id => "#{object}_#{method}_select_auto_complete", :class => "select_auto_complete") +
    select_auto_complete_field("#{object}_#{method}", { :url => { :action => "select_auto_complete_for_#{object}_#{method}" } }.update(completion_options))
  end


  def combo_box_tag_auto_complete(id,value, url, tag_options = {}, completion_options = {})
    text_field_tag(id, value, tag_options) +
    content_tag("div", "", :id => "#{id}_select_auto_complete", :class => "select_auto_complete") +
    select_auto_complete_field("#{id}", { :url => url }.update(completion_options))
  end
end

module SelectAutocompleterActionHelper
      # Example:
      #
      #   # Controller
      #   class BlogController < ApplicationController
      #     select_auto_complete_for :post, :title
      #   end
      #
      #   # View
      #   <%= text_field_with_select_auto_complete :post, title %>
      #
      # By default, select_auto_complete_for sorts by the given field.
      # 
      # select_auto_complete_for takes a third parameter, an options hash to
      # the find method used to search for the records and a :idField option
      # for the value field of the select element returned (default is id):
      # Extra option: :idField the name of the identitity field if in is not 'id'
      #
      #   select_auto_complete_for :post, :title, :id, :limit => 15, :order => 'created_at DESC'
      #
  def select_auto_complete_for(object, method, options = {})
    define_method("select_auto_complete_for_#{object}_#{method}") do
      idField = options[:idField] ? options[:idField] : "id"
      options.delete(:idField) if options[:idField]
      find_options = { 
        :conditions => [ "LOWER(#{method}) LIKE ?", params[object][method].downcase + '%' ], 
        :order => "#{method} ASC" }.merge!(options)
              
              @items = object.to_s.camelize.constantize.find(:all, find_options)
  
              render :inline => "<%= select_auto_complete_result @items, '#{method}', '#{idField}' %>"
    end 
  end
end