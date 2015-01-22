require 'slack/post'
class PostsController < ApplicationController
  def index
    @page = params[:index] ? params[:index].to_i : 1
    @page_count = (Post.count / 10.0).ceil
    @page_path_base = '/page'
    @posts = Post.posts_for_page(@page, 10).select { |post| !post.blank? }
    as = @active_session || active_session
    @votes = as ? Vote.where('session_id=(?) AND post_id IN (?)', as.id, @posts.map(&:id)) : []
    @is_logged_in = false
    if !cookies.signed[:remember_token].blank?
      @is_logged_in = Contributor.exists?(remember_token: cookies.signed[:remember_token])
    end
  end

  def show
    @post = Post.find(params[:id])
    @vote = Vote.find_by_post_id_and_session_id(params[:id], @active_session.id)
    @is_logged_in = false
    if !cookies.signed[:remember_token].blank?
      @is_logged_in = Contributor.exists?(remember_token: cookies.signed[:remember_token])
    end
  end

  include PostsHelper
  def create
    if cookies.signed[:remember_token].blank?
      render html: '<p>Sign in to post</p>' and return
    end
    @author = Contributor.find_by_remember_token(cookies.signed[:remember_token])
    new_post = Post.new(post_params)
    new_post.contributor = @author
    new_post.process_player_embed(params[:post][:original_code])
    new_post.is_deleted = false
    new_post.save
    new_post.save_content(params[:post][:tagged_texts], params[:post][:tag_ranges], @author)
    new_post.save_tags(params[:post][:tags_text], @author)

    @is_logged_in = false
    if !cookies.signed[:remember_token].blank?
      @is_logged_in = Contributor.exists?(remember_token: cookies.signed[:remember_token])
    end

    message = "New post from #{ @author.name }: #{ full_path_for_post(new_post) }"
    Slack::Post.configure(
      subdomain: 'tunetap',
      token: 'lljf8ejjZ815ADXV9wVsMe25',
      username: 'Camelback Post'
    )
    Slack::Post.post message, '#camelback' if Rails.env.production?

    render_post_partial(new_post, nil, false, @is_logged_in)
  end

  def edit
    @post = Post.find(params[:id])
  end

  include ApplicationHelper
  def update
    if is_not_contributor
      render status: :unauthorized and return
    end
    @author = Contributor.find_by_remember_token(cookies.signed[:remember_token])
    post = Post.find(params[:id])
    post.update_attributes(post_params)
    post.process_player_embed(params[:post][:original_code])
    post.save
    post.save_content(params[:post][:tagged_texts], params[:post][:tag_ranges], @author)
    post.save_tags(params[:post][:tags_text], @author)
    # post.save
    render json: { success: true, post_path: post_path(post) }
  end

  def destroy
    if is_not_contributor
      render status: :unauthorized and return
    end
    post = Post.find(params[:id])
    post.is_deleted = true
    post.save
    render json: { success: 1 }
  end

  private
  def post_params
    params.require(:post).permit(
      :image_url,
      :download_link, 
      :twitter_text, 
      :facebook_text, 
      :is_deleted, 
      :original_code
    )
  end
end
