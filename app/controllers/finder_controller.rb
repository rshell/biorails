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

     
end
