##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

class Organize::QueueItemsController < ApplicationController

  use_authorization :queue_items,
                    :actions => [:show,:destroy],
                    :rights => :current_project
                      
  def show
    @queue_item = QueueItem.find(params[:id])
  end

  def destroy
    QueueItem.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
