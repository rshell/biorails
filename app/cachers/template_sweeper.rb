class TemplateSweeper < ActionController::Caching::Sweeper
  include Biorails::SweeperMethods
  #observe Template

  # only sweep updates, not creations
  # tagged 'lame hack'
  def before_save(record)
    @new = record.new_record?
  end

  def after_save(record)
    project.expire_cached_pages controller, "Expired all referenced pages" if @new.nil? && controller
  end
end