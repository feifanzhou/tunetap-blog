class SubscribersController < ApplicationController
  def create
    params = subscriber_params
    post = Post.find params[:post_id]
    message = "Subscriber from Post #{ post.id } (#{ post.title_text }): #{ params[:email] }"
    Slack::Post.configure(
      subdomain: 'tunetap',
      token: 'lljf8ejjZ815ADXV9wVsMe25',
      username: 'Camelback Subscriber'
    )
    Slack::Post.post message, '#camelback'# if Rails.env.production?
    render json: { success: true }
  end

  private
  def subscriber_params
    params.require(:subscriber).permit(:post_id, :email)
  end
end
