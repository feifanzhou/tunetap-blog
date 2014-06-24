module TagsHelper
  include ActionView::Helpers::UrlHelper
  def link_to_tag(tag)
    return link_to tag.name, tag.path_with_slug
  end

  def tags_like(query)
    # http://stackoverflow.com/a/15245691/472768
    Tag.where('lower(name) LIKE ?', "#{ query.downcase }%").to_a
  end
end
