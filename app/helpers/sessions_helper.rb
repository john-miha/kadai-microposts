module SessionsHelper
  def current_user
    # ||= は、すでに現在のユーザーが代入されていたら何もせず、
    #空の場合はfind_byの結果を代入する。
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    #これは、"current_userがTrueの場合はTrue, Falseの場合はFalseを返す"ための記法。
    !!current_user
  end
end