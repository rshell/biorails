class PageController < ApplicationController

  def show
  end

##
# return a file asset by primilink id
#   
  def asset
      @assert = ProjectAssert.find_by_path(path)
      respond_to do | format |
        format.html { render :inline=> @assert.to_html }
        format.xml  { render :xml=> @assert.to_xml}
      end
  end

##
# return a piece of content by primilink id
#   
  def content
    @content = ProjectAssert.find_by_path(path)
    respond_to do | format |
      format.html { render :inline=> @content.to_html }
      format.xml  { render :xml=> @content.to_xml}
    end
  end
  
  def locate
     if params[:path]
       path = params[:path].join('/')
       @element = ProjectElement.find_by_path(path)
        respond_to do | format |
          format.html { render :inline=> @element.to_html }
          format.xml  { render :xml=> @element.to_xml}
        end
    end
  end
end
