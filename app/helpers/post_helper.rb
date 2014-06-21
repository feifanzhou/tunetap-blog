module PostHelper
  def get_posts_by_tag(tag, page, posts_per_page)
    tag.posts.limit(posts_per_page).offset(page - 1).to_a
  end
end