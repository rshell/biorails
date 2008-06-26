##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

class AuditController < ApplicationController

  use_authorization :audit,
                    :actions => [:show],
                    :rights => :current_user  

  def show
    @audits = Audit.find(:all,
      :conditions=>['auditable_type=? and auditable_id =?',params[:auditable_type],params[:id]],
      :order=>'created_at desc',:limit=>100)
    @root = @audits[0].auditable if @audits.size>0
    respond_to do | format |
      format.json { render :json => {:root=>@root,:items=> @audits}.to_json }
      format.xml  { render :xml => {:user=>@root,:items=> @audits}.to_xml }
      format.js   { 
         render :update do | page |
           page.replace_html 'audit_log',  :partial => 'show' 
         end          
         }
      format.html { render :action => 'show' }
    end
  end

  
end
