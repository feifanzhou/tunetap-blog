# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
author = Contributor.create(is_admin: true, name: 'Feifan Zhou', email: 'feifan@tunetap.com', password: 'letmein')
post = Post.new(image_url: 'http://ozbeautyexpert.com/wp-content/uploads/2013/07/Lana+Del+Rey++600x600+PNG+diffe.png', player_embed: '<a data-width="358" data-bop-link href="http://bop.fm/s/lana-del-rey/west-coast">Lana Del Rey - West Coast | Listen for free at bop.fm</a><script async src="http://assets.bop.fm/embed.js"></script>', player_type: 'bopfm', twitter_text: 'Camelback test')
post.contributor = author
post.save
lana_tag = Tag.new(name: 'Lana Del Rey', tag_type: 'artist')
lana_tag.contributor = author
lana_tag.save
title = TaggedText.new(content_type: 'title', content: 'Check out Lana Del Rey’s new single West Coast')
title.post = post
title.save
body = TaggedText.new(content_type: 'body', content: 'Helvetica seitan Austin slow-carb, quinoa iPhone tousled jean shorts 3 wolf moon before they sold out next level literally photo booth Williamsburg. Kickstarter fashion axe chillwave, Helvetica try-hard wayfarers scenester 8-bit squid mlkshk ennui. Ugh +1 farm-to-table kitsch, small batch Bushwick keffiyeh cray viral. High Life quinoa Etsy, Thundercats Marfa Pitchfork Tumblr jean shorts mustache stumptown viral lomo small batch keytar. Tattooed viral brunch, squid Williamsburg Thundercats swag umami. Cornhole Banksy forage, disrupt 90s art party artisan aesthetic craft beer bicycle rights umami seitan pickled organic. Beard banjo actually roof party cray YOLO street art literally.')
body.post = post
body.save
tag_range = TagRange.new(start: 10, length: 12)
tag_range.tagged_text = title
tag_range.tag = lana_tag
tag_range.save