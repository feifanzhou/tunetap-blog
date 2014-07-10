class PostsController < ApplicationController
  def index
    @page = params[:index] ? params[:index].to_i : 1
    @page_count = (Post.count / 10.0).ceil
    @page_path_base = '/page'
    @posts = Post.posts_for_page(@page, 10).select { |post| !post.blank? }
    @is_logged_in = false
    if !cookies.signed[:remember_token].blank?
      @is_logged_in = Contributor.exists?(remember_token: cookies.signed[:remember_token])
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  include PostsHelper
  def create
    if cookies.signed[:remember_token].blank?
      render html: '<p>Sign in to post</p>' and return
    end
    @author = Contributor.find_by_remember_token(cookies.signed[:remember_token])
    new_post = Post.new(post_params)
    new_post.contributor = @author
    new_post.process_player_embed(params[:post][:embed_link])
    new_post.is_deleted = false
    new_post.save
    new_post.save_content(params[:post][:tagged_texts], params[:post][:tag_ranges], @author)
    render_post_partial(new_post, true)
  end

  include ApplicationHelper
  def update
    if is_not_contributor
      render status: :unauthorized and return
    end
    post = Post.find(params[:id])
    post.is_deleted = params[:post][:is_deleted]
    post.save
    render json: { success: 1 }
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
    params.require(:post).permit(:image_url, :download_link, :twitter_text, :facebook_text, :is_deleted)
  end
end
