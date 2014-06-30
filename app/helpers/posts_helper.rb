module PostsHelper
  def fb_buttons_for_post(post)
    "<div class='fb-like' data-href='#{ full_path_for_post(post) }' data-layout='button_count' data-action='like' data-show-faces='false' data-share='true'></div>".html_safe
  end
  def full_path_for_post(post, should_include_slug = true)
    url = "#{ ENV['ROOT_URL'] }"
    if should_include_slug
      url << "#{ post.path_with_slug }"
    else
      url << "/posts/#{ post.id }"
    end
    return url
  end
  def get_posts_by_tag(tag, page, posts_per_page)
    tag.posts.limit(posts_per_page).offset(page - 1).to_a
  end
  def twitter_button_for_post(post)
    "<a href='https://twitter.com/share' class='twitter-share-button' data-text='#{ post.twitter_text }' data-url='#{ full_path_for_post(post, false) }' data-via='CamelbackMusic'>Tweet</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>".html_safe
  end

  def render_post_partial(post, is_new_post = false, is_logged_in = false)
    if post.player_type == 'bopfm'
      render partial: 'shared/post_body_bop', formats: [:html], locals: { post: post, is_new_post: is_new_post, is_logged_in: is_logged_in }
    elsif post.player_type == 'soundcloud'
      render partial: 'shared/post_body_soundcloud', formats: [:html], locals: { post: post, is_new_post: is_new_post, is_logged_in: is_logged_in }
    else
      render html: '<p>Invalid post embed format</p>'.html_safe
    end
  end
end
