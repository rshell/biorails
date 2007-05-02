class AuditController < ApplicationController

  def show
    @audits = Audit.find(:all,:conditions=>['auditable_type=? and auditable_id =?',params[:auditable_type],params[:id]],:order=>'created_at desc')
    @root = @audits[0].auditable if @audits.size>0
  end

end
