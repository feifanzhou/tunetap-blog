module HeaderCookies
  def header_cookies(req=nil)
    req ||= request
    batter = request.headers['Cookie']
    return Hash.new unless batter
    cookie_dough = batter.split '; '
    Hash[cookie_dough.map do |c| 
      pieces = c.split '='
      [pieces[0].to_sym, pieces[1]]
    end]
  end
end