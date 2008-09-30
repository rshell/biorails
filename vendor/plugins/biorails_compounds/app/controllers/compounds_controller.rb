##
# Copyright � 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# needs gem install rcdk
# 

class CompoundsController < ApplicationController

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @compounds = Compound.paginate :order=>'name desc', :page => params[:page]
  end

  def show
    @compound = Compound.find(params[:id])
    respond_to do |format|
     format.html # show.rhtml
     format.xml  { render :xml => @compound.to_xml }
     format.json { render :text => @compound.to_json }
   end
  end

  def new
    @compound = Compound.new
  end

  def create
    @compound = Compound.new(params[:compound])     
    if @compound.save
      flash[:notice] = 'Compound was successfully created.'
      redirect_to :action => 'show', :id => @compound.id
    else
      render :action => 'new'
    end
  end

  def edit
    @compound = Compound.find(params[:id])
  end

  def update
  
    @compound = Compound.find(params[:id])
    if @compound.update_attributes(params[:compound])
      redirect_to :action => 'show', :id => @compound.id
    else
      render :action => 'edit'
    end 
    
  end

## Smiles depiction
  def depict
    if params[:smiles]
      @smiles = params[:smiles][:value]
    else
      @smiles = ''
    end
  end
  
  
  def destroy
    Compound.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
