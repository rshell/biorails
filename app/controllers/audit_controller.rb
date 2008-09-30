# == Description
# This provides actions to view the audit trail for a even model
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class AuditController < ApplicationController

  use_authorization :audit,
                    :actions => [:show],
                    :rights => :current_user  
#
# This displays the audit trail for last 100 changes to a given record
# Eg for changes to project 1 its :-
# 
#  /audit/show/1?auditable_type=Project
#  
#  @params
# * params[:auditable_type] Class name
# * params[:id] Id
# 
#
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
