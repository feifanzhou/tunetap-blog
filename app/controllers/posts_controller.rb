class PostsController < ApplicationController
  def index
    @posts = Post.posts_for_page(1, 10)
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    new_post = Post.new(post_params)
    new_post.process_player_embed(params[:post][:embed_link])
    new_post.save
  end

  private
  def post_params
    params.require(:post).permit(:image_url, :download_link, :twitter_text, :facebook_text)
  end
end
