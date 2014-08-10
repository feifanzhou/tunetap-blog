module TagsHelper
  include ActionView::Helpers::UrlHelper
  def link_to_tag(tag, new_page=false)
    html_options = new_page ? { target: '_blank' } : {}
    return link_to tag.name, tag.path_with_slug, html_options
  end

  def tags_like(query)
    # http://stackoverflow.com/a/15245691/472768
    Tag.where('lower(name) LIKE ?', "#{ query.downcase }%").to_a
  end
end
