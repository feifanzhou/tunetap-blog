module ApplicationHelper
  def is_not_contributor
    !is_contributor
  end
  def is_contributor
    !cookies.signed[:remember_token].blank? && Contributor.exists?(remember_token: cookies.signed[:remember_token])
  end
end
