class Organize::QueueItemsController < ApplicationController

  use_authorization :study,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_project
                      

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @queue_item_pages, @queue_items = paginate :queue_items, :per_page => 10
  end

  def show
    @queue_item = QueueItem.find(params[:id])
  end

  def new
    @queue_item = QueueItem.new
  end

  def create
    @queue_item = QueueItem.new(params[:queue_item])
    if @queue_item.save
      flash[:notice] = 'QueueItem was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @queue_item = QueueItem.find(params[:id])
  end

  def update
    @queue_item = QueueItem.find(params[:id])
    if @queue_item.update_attributes(params[:queue_item])
      flash[:notice] = 'QueueItem was successfully updated.'
      redirect_to :action => 'show', :id => @queue_item
    else
      render :action => 'edit'
    end
  end

  def destroy
    QueueItem.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
