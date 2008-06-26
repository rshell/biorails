##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

module Project::ArticlesHelper
  FILTER_TYPES = %w(approved unapproved) unless const_defined?(:FILTER_TYPES)

  def status_icon
    @status_icon ||= { :unpublished => %w(orange bstop.gif),
                       :pending     => %w(yellow document.gif),
                       :published   => %w(green check.gif) }
  end

  def link_to_article(article)
    return '' unless article
    article.published? ?
      link_to(h(article.title), current_project.permalink_for(article)) :
      h(article.title)
  end

  def published_at_for(article)
    return 'not published' unless article && article.published?
    utc_to_local(article.published_at).to_ordinalized_s(article.published_at.year == Time.now.utc.year ? :stub : :mdy)
  end

  def valid_filter?(filter = params[:filter])
    FILTER_TYPES.include? filter
  end
  
  def has_excerpt?
    return false unless @article.excerpt 
    @article.excerpt.length > 0
  end
end
