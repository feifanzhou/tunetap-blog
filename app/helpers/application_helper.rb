module ApplicationHelper
  def is_not_contributor
    !is_contributor
  end
  def is_contributor
    !cookies.signed[:remember_token].blank? && Contributor.exists?(remember_token: cookies.signed[:remember_token])
  end

  def active_contributor
    return nil if is_not_contributor
    Contributor.find_by_remember_token(cookies.signed[:remember_token])
  end
end
