module TagsHelper
  include ActionView::Helpers::UrlHelper
  def link_to_tag(tag)
    return link_to tag.name, tag.path_with_slug
  end
end
