##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class FinderController < ApplicationController
 
   def query
     text = params.keys[0]
     @hits = Array.new
     if !text.empty?
        text += "%"
        puts text
        @hits.concat Study.find(:all,:conditions =>["name like ?",text], :limit=>5)
        @hits.concat Experiment.find(:all,:conditions =>["name like ?",text], :limit=>5)
        @hits.concat Task.find(:all,:conditions =>["name like ?",text], :limit=>5)
        if @hits.size < 6
         @hits.concat ParameterType.find(:all,:conditions =>["name like ?",text], :limit=>5)
        end 
        if @hits.size < 6
         @hits.concat Compound.find(:all,:conditions =>["name like ?",text], :limit=>5)
         @hits.concat Batch.find(:all,:conditions =>["name like ?",text], :limit=>5)
         @hits.concat Plate.find(:all,:conditions =>["name like ?",text], :limit=>5)
        end 
     end 
     session[:hits] = @hits
     render :partial => 'shared/hitlist', :layout => false      
   end

##
# Show the finder on the left hand panel
#   
  def left_show
     session[:left_panel]=true
     render :update do |page|
        page.visual_effect :blind_down,'left_content', {:duration=>0.5, :scaleX=>true, :scaleY=>true}
        page.visual_effect :blind_up,'left_closed',{:duration=>0.5,:scaleX=>true, :scaleY=>true}
     end
  end

##
# Hide the finder on the left hand panel
#   
  def left_hide
     session[:left_panel]=false
     render :update do |page|
        page.visual_effect :blind_up,'left_content', {:duration=>0.5,:scaleX=>true, :scaleY=>true}
        page.visual_effect :blind_down,'left_closed',{:duration=>0.5,:scaleX=>true, :scaleY=>true}
        page['left_closed'].show
     end
  end

##
# Show the finder on the left hand panel
#   
  def right_show
     session[:right_panel]=true
     render :update do |page|
        page.visual_effect :blind_up,'right_closed',{:duration=>0.5,:scaleX=>true, :scaleY=>true}
        page.visual_effect :blind_down,'right_content', {:duration=>0.5,:scaleX=>true, :scaleY=>true}
     end
  end

##
# Hide the finder on the left hand panel
#   
  def right_hide
     session[:right_panel]=false
     render :update do |page|
        page.visual_effect :blind_up,'right_content', {:duration=>0.5,:scaleX=>true, :scaleY=>true}
        page.visual_effect :blind_down,'right_closed',{:duration=>0.5,:scaleX=>true, :scaleY=>true}
     end
  end
     
end
