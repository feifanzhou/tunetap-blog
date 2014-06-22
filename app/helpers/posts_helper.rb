module PostsHelper
  def fb_buttons_for_post(post)
    "<div class='fb-like' data-href='#{ full_path_for_post(post) }' data-layout='button_count' data-action='like' data-show-faces='false' data-share='true'></div>".html_safe
  end
  def full_path_for_post(post)
    "#{ ENV['ROOT_URL'] }#{ post.path_with_slug }"
  end
  def get_posts_by_tag(tag, page, posts_per_page)
    tag.posts.limit(posts_per_page).offset(page - 1).to_a
  end
  def twitter_button_for_post(post)
    "<a href='#{ full_path_for_post(post) }' class='twitter-share-button' data-text='#{ post.twitter_text }' data-via='CamelbackMusic'>Tweet</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>".html_safe
  end
end
