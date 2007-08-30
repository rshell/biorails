class AuditController < ApplicationController

  use_authorization :audit,
                    :actions => [:show],
                    :rights => :current_user  

  def show
    @audits = Audit.find(:all,:conditions=>['auditable_type=? and auditable_id =?',params[:auditable_type],params[:id]],:order=>'created_at desc')
    @root = @audits[0].auditable if @audits.size>0
    respond_to do | format |
      format.html { render :action => 'show' }
      format.json { render :json => {:root=>@root,:items=> @audits}.to_json }
      format.xml  { render :xml => {:user=>@root,:items=> @audits}.to_xml }
      format.js   { render :update do | page |
           page.replace_html 'audit_log',  :partial => 'show' 
         end }
      #format.ical  { render :text => >@calendar@user.calendar.to_ical}
    end
  end

end
