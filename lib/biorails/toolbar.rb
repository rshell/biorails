module Biorails #:nodoc:
  module Toolbar
    module ToolbarHelper 
      
      # Renders the application main menu
      def render_toolbar
         out = []
         Biorails::Toolbar.items do |item|
            out << render_button(item)
            out << render_menu(item) if item.is_a?(Menu)            
         end
      end
      #
      # Render a button 
      #
      def render_button(button)
        url = case button.url
                  when Hash then    url_for(button.url) # convert hash to a url string
                  when Symbol then  send(button.url) # call method to for url
                  else  
                    button.url # Return url string
                  end
        out << {:iconCls=> '#{button.icon}',:handler=> "function(){window.location='#{url}'}"}        
      end
      #
      # Render a Menu
      #
      def render_menu(menu)
        links = []
        menu.each do |item|
          unless item.condition && !item.condition.call(project,user)
            url = case item.url
                  when Hash then    url_for(item.url) # convert hash to a url string
                  when Symbol then  send(item.url) # call method to for url
                  else  
                    item.url # Return url string
                  end
            links << {:text=>item.name, :iconCls=> item.icon,:href => item.url}
          else  
            links << {:text=>item.name, :cls=>'x-item-disabled'}
          end
        end
        return {:text => title, :menu=> { :items => links  } }
      end

   end
    #
    # Define the functions to manage the static menus
    #
    class << self
    #
    # Add button to the toolbar
    #
      def add_button(key,name,icon,url={},condition={})
        button = Button.new(name,icon,url,condition)
        yield button
        @items ||= {}
        @items[key] ||= []
        @items[key] << button
      end
    #
    # Add a menu to the toolbar
    #
      def add_menu(key,name,icon,url={},condition={})
        menu = Menu.new(name,icon,url,condition)
        yield menu
        @items ||= {}
        @items[key] ||= []
        @items[key] << menu
      end

      def items
        @items
      end
      
      def item(key)
        @items[key.to_sym] || []
      end

    end
    #
    # General Menu Item
    #
    class MenuItem
      attr_reader :name,:icon, :url, :param, :condition
      
      def initialize(name, url, options={})
        raise "Invalid option :if for menu item '#{name}'" if options[:if] && !options[:if].respond_to?(:call)
        @name = name
        @url = url
        @condition = options[:if]
        @param = options[:param] || :id
        @html_options = options[:html] || {}
      end
      
    end    
    #
    # Add a button to the the top menu bar
    #
    class Button
      attr_reader :name,:icon, :url, :param, :condition

      def initialize(name,icon=nil, url={}, options={})
        @name = name
        @url = url
        @icon = icon
        @condition = options[:if]
        @param = options[:param] || :id
        @html_options = options[:html] || {}
      end
          
    end
    #
    # Add a menu to the top ToolBar
    #
    class Menu
      attr_reader :name,:icon, :url, :param, :condition

      def initialize(name,icon=nil, url={}, options={})
        @name = name
        @url = url
        @icon = icon
        @condition = options[:if]
        @param = options[:param] || :id
        @html_options = options[:html] || {}
      end

      # Adds an item at the end of the menu. Available options:
      # * param: the parameter name that is used for the project id (default is :id)
      # * if: a proc that is called before rendering the item, the item is displayed only if it returns true
      # * caption: the localized string key that is used as the item label
      # * html_options: a hash of html options that are passed to link_to
      def add_item(name, url, options={})
        items << MenuItem.new(name, url, options)
      end
      
      def project_list
        
      end
      #
      # List of menu items
      #
      def items
        @items ||= []
      end
    end

  
 end

end

  
