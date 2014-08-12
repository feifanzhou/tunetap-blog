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
    tag.posts.includes(:tags, :contributor).limit(posts_per_page).offset((page - 1) * posts_per_page).to_a
  end
  def twitter_button_for_post(post)
    "<a href='https://twitter.com/share' class='twitter-share-button' data-text='#{ post.twitter_text }' data-url='#{ full_path_for_post(post, false) }' data-via='CamelbackMusic'>Tweet</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>".html_safe
  end

  def render_post_partial(post, vote = nil, is_new_post = false, is_logged_in = false)
    if post.player_type == 'bopfm'
      render partial: 'shared/post_body_bop', formats: [:html], locals: { post: post, vote: vote, is_new_post: is_new_post, is_logged_in: is_logged_in }
    elsif post.player_type == 'soundcloud'
      render partial: 'shared/post_body_soundcloud', formats: [:html], locals: { post: post, vote: vote, is_new_post: is_new_post, is_logged_in: is_logged_in }
    elsif post.player_type == 'spotify'
      render partial: 'shared/post_body_spotify', formats: [:html], locals: { post: post, vote: vote, is_new_post: is_new_post, is_logged_in: is_logged_in }
    elsif post.player_type == 'youtube'
      render partial: 'shared/post_body_youtube', formats: [:html], locals: { post: post, vote: vote, is_new_post: is_new_post, is_logged_in: is_logged_in }
    elsif post.player_type == 'vimeo'
      render partial: 'shared/post_body_vimeo', formats: [:html], locals: { post: post, vote: vote, is_new_post: is_new_post, is_logged_in: is_logged_in }
    # else
    #   render html: '<p>Invalid post embed format</p>'.html_safe
    end
  end

  def process_bop_embed(post, embed_link)
    post.player_embed = embed_link
    post.player_type = 'bopfm'
  end
  def process_soundcloud_embed(post, embed_link)
    src_index = embed_link.index 'src='
    unless src_index.blank?
      src_index += 5
      end_index = embed_link.index('>') - 2
      new_link = embed_link[src_index..end_index]
    end

    color_index = new_link.index('color=')
    if color_index.blank?
      amp_index = new_link.index('&amp;')
      color_str = "&amp;color=#{ Post.embed_color }"
      new_link.insert(amp_index, color_str)
    else
      color_index += 6
      color_end_index = color_index + 6
      new_link[color_index...color_end_index] = Post.embed_color
    end

    # FIXME — Visual removal not working yet
    visual_index = new_link.index('visual=true')
    new_link = new_link[0...visual_index] if !visual_index.blank?

    post.player_embed = new_link
    post.player_type = 'soundcloud'
  end
  def process_spotify_embed(post, embed_link)
    uri_index = embed_link.index 'spotify:'
    if uri_index == 0  # Link is just URI
      spotify_uri = embed_link
    else  # Extract URL from embed code
      comps = embed_link.split
      src = comps.find{ |c| c.index('src=') == 0 }
      uri_start_index = src.index('uri=') + 4
      uri_end_index = src.index('&') || (src.length - 1) # -1 for end quote
      spotify_uri = src[uri_start_index...uri_end_index]
    end
    post.player_embed = spotify_uri
    post.player_type = 'spotify'
  end
  def process_youtube_embed(post, embed_link)
    start_index = embed_link.index '?v='
    if !start_index  # Got embed code
      start_index = embed_link.index('/embed') + 7
      end_index = embed_link.index('?rel') || embed_link.index('"', start_index)
      end_index -= 1  # Don't want any of that other stuff
    else  # Got URL
      start_index += 3
      end_index = embed_link.index('&') || (embed_link.length - 1)
    end
    youtube_uri = embed_link[start_index..end_index]
    post.player_embed = youtube_uri
    post.player_type = 'youtube'
  end
  def process_vimeo_embed(post, embed_link)
    if embed_link.include? 'src='  # Got embed code
      start_index = embed_link.index('src=') + 30
      end_index = embed_link.index('?', start_index) || embed_link.index('"', start_index)
      vimeo_uri = embed_link[start_index...end_index]  # Yes, three dots
    else  # Got URL
      pieces = embed_link.split('/')
      vimeo_uri = pieces.last
    end
    post.player_embed = vimeo_uri
    post.player_type = 'vimeo'
  end
  def process_unknown_embed(post, embed_link)
    post.player_type = 'unknown'
  end
end
