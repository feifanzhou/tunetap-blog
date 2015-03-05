namespace :clear_unused do
  desc 'Find and remove sessions where visitors did not vote and have not come back'
  task sessions: :environment do
    sessions = Session.where("(sessions.last_active - sessions.created_at) < interval '12 hours' AND NOT EXISTS (SELECT 1 FROM votes WHERE votes.session_id = sessions.id)")
    sessions.delete_all
  end
end
