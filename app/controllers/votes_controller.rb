class VotesController < ApplicationController
  include VotesHelper
  def create
    current_vote = current_vote_with_post_id(params[:post_id])
    if current_vote.blank?
      current_vote = Vote.new(post_id: params[:post_id], session_id: active_session.id)
    end
    current_vote.is_deleted = params[:is_deleted]
    current_vote.is_upvote = params[:is_upvote]
    current_vote.save
    render json: { success: true }
  end

  def update
  end
end
