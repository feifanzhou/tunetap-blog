module VotesHelper
  include SessionsHelper
  def current_vote_with_post_id(post_id)
    sesh = active_session
    Vote.find_by_post_id_and_session_id(post_id, sesh.id)
  end
end
