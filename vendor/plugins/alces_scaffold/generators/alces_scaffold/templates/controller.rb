class <%= controller_class_name %>Controller < ApplicationController
  #
  # Get the current page of <%= table_name %> tables
  # 
  # GET /<%= table_name %>
  # GET /<%= table_name %>.xml
  # GET /<%= table_name %>.csv
  # GET /<%= table_name %>.json
  #
  def list
    @<%= table_name %> = get_page

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @<%= table_name %>.to_xml }
      format.csv  { render :text => @<%= table_name %>.to_csv }
      format.json { render :json =>  <%= table_name %>_to_json(@<%= table_name %>, <%= class_name %>.count, params[:page]), :layout=>false }  
      format.js  { render :update do | page |  
          page.actions_panel  :partial => 'actions'
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial =>'list'
       end 
      }
    end
  end
  #
  # Alias to list
  #
  def index 
    list    
  end
  #
  # Show the current <%= file_name %> value
  #
  # GET /<%= table_name %>/1
  # GET /<%= table_name %>/1.xml
  def show
    @<%= file_name %> = <%= class_name %>.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @<%= file_name %>.to_xml }
      format.json  { render :text => @<%= file_name %>.to_json }
      format.js  { render :update do | page |  
          page.actions_panel  :partial => 'actions'
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial => 'show'
       end      
      }
    end
  end

  #
  # Get data for a ext grid <%= file_name %> value
  #
  # GET /molecules/grid
  #
  def grid
    @<%= table_name %> =  get_page
    render :text =>  <%= table_name %>_to_json(@<%= table_name %>, <%= class_name %>.count, params[:page]), :layout=>false 
  end
  #
  # Show a new record form to be filled in
  # params[:id] primary key of the record
  #
  # GET /<%= table_name %>/new
  #
  def new
    @<%= file_name %> = <%= class_name %>.new
    respond_to do |format|
      format.html # new.rhtml
      format.xml  { render :xml => @<%= file_name %>.to_xml }
      format.json  { render :text => @<%= file_name %>.to_json }
      format.js  { render :update do | page |  
          page.actions_panel  :partial => 'actions'
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial => 'new'
        end
      }
     end  end
  #
  # Show a edit form of the current record
  # params[:id] primary key of the record
  #
  # GET /<%= table_name %>/1;edit
  #
  def edit
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    respond_to do |format|
      format.html # edit.rhtml
      format.xml  { render :xml => @<%= file_name %>.to_xml }
      format.json  { render :text => @<%= file_name %>.to_json }
      format.js  { render :update do | page |  
          page.actions_panel  :partial => 'actions'
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial => 'edit'
        end
      }
    end
  end

  #
  # Create a <%= file_name %> bassed on passed data
  # params[:<%= file_name %>][<columns>] contain the data
  # 
  # POST /<%= table_name %>
  # POST /<%= table_name %>.xml
  def create
    @<%= file_name %> = <%= class_name %>.new(params[:<%= file_name %>])

    respond_to do |format|
      if @<%= file_name %>.save
        flash[:notice] = '<%= class_name %> was successfully created.'
        format.html { redirect_to <%= singular_name %>_url() }
        format.xml  { head :created, :location => <%= file_name %>_url(@<%= file_name %>) }
        format.js  { render :update do | page |  
            page.actions_panel  :partial => 'actions'
            page.help_panel     :partial => 'help'
            page.status_panel   :partial => 'status'
            page.main_panel     :partial => 'show'
          end
         }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= file_name %>.errors.to_xml }
        format.js  { render :update do | page |  
            page.actions_panel  :partial => 'actions'
            page.help_panel     :partial => 'help'
            page.status_panel   :partial => 'status'
            page.main_panel     :partial => 'new'
          end
         }
      end
    end
  end

  # PUT /<%= table_name %>/1
  # PUT /<%= table_name %>/1.xml
  def update
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    respond_to do |format|
      if @<%= file_name %>.update_attributes(params[:<%= file_name %>])
        flash[:notice] = '<%= class_name %> was successfully updated.'
        format.html { redirect_to <%= singular_name %>_url() }
        format.xml  { head :ok }
        format.js  { render :update do | page |  
            page.actions_panel  :partial => 'actions'
            page.help_panel     :partial => 'help'
            page.status_panel   :partial => 'status'
            page.main_panel     :partial => 'show'
          end
         }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= file_name %>.errors.to_xml }
        format.js  { render :update do | page |  
            page.actions_panel  :partial => 'actions'
            page.help_panel     :partial => 'help'
            page.status_panel   :partial => 'status'
            page.main_panel     :partial => 'edit'
          end
         }
      end
    end
  end

  # DELETE /<%= table_name %>/1
  # DELETE /<%= table_name %>/1.xml
  def destroy
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    @<%= file_name %>.destroy

    respond_to do |format|
      format.html { redirect_to <%= singular_name %>_url() }
      format.xml  { head :ok }
      format.js  { render :update do | page |  
            page.actions_panel  :partial => 'actions'
            page.help_panel     :partial => 'help'
            page.status_panel   :partial => 'status'
            page.main_panel     :partial => 'list'
          end
      }
    end  
  end

protected  
#
# Get the current page of objects
# 
  def get_page
    start = (params[:start] || 1).to_i      
    size = (params[:limit] || 25).to_i 
    sort_col = (params[:sort] || 'id')
    sort_dir = (params[:dir] || 'ASC')
    page = ((start/size).to_i)+1   
    return <%= class_name %>.find(:all, 
           :limit=> size,
           :offset=> start, 
           :order=> sort_col+' '+sort_dir)
  end

  def <%= table_name %>_to_json(items,total,page)
    data = {:total => <%= class_name %>.count}
    data[:items] = items.collect {|i|i.attributes}
    data.to_json  
  end

  def <%= file_name %>_to_json(item)
    data = {:class => item.class.to_s, 
            :table => item.class.table_name,
            :columns=> item.class.columns,
            :data => item.attributes}
    data.to_json  
  end

          
end
