# == Queue Item Controller
# This is used to display a queue item and allows the user to delete it
#
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
class Organize::QueueItemsController < ApplicationController

  use_authorization :organization,
                    :actions => [:show,:destroy],
                    :rights => :current_user
                         
  def show
    @queue_item = QueueItem.find(params[:id])
  end

  def destroy
    QueueItem.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
