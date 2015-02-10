desc 'Add enable_api to Soundcloud embeds'
task enable_soundcloud_api: :environment do
  include PostsHelper
  Post.where(player_type: 'soundcloud').each do |post|
    process_soundcloud_embed(post, post.original_code)
    post.save
  end
end