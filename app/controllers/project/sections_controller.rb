class Project::SectionsController < Project::BaseController
  cache_sweeper :article_sweeper, :except => :index
#  before_filter :find_and_reorder_sections, :only => [:index, :edit]
#  before_filter :find_section,              :only => [:destroy, :update]
  clear_empty_templates_for :section, :template, :layout, :archive_template, :only => [:create, :update]

  def index
    @section = Section.new
  end

  def create
    @section = current_project.sections.create(params[:section])
  end

  def destroy
    @section.destroy
    render :update do |page|
      page.visual_effect :drop_out, "section-#{params[:id]}"
    end
  end

  def update
    @section.update_attributes params[:section]
  end

  def order
    if params[:id].to_i == 0
      site.sections.order! params[:sorted_ids]
    else
      find_section
      @section.order! params[:sorted_ids]
    end
    render :nothing => true
  end

  protected

    def find_and_reorder_sections
      @article_count = current_project.sections.articles_count
      @sections      = current_project.sections
      @sections.each do |s|
        @home    = s if s.home?
        @section = s if params[:id].to_s == s.id.to_s
      end
    end
    
    def find_section
      @section = current_project.sections.find params[:id]
    end

    alias authorized? admin?
end
