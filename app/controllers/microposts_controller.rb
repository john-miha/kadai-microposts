class MicropostsController < ApplicationController
  #application_controllerに定義した共通のメソッド
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy] 
  def create
    @micropost = current_user.microposts.build(micropost_params)
    
    if @micropost.save
      flash[:success] = "メッセージを投稿しました"
      redirect_to root_url
    else
      @pagy, @microposts =pagy(current_user.feed_micropost.order(id: :desc))
      flash.now[:danger] = "メッセージの投稿に失敗しました"
      render "toppages/index"
    end
    
    
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)

  end
  
  private
  
  #Require(モデル名)に指定したモデルのフォームから得られるデータについて、
  #Permit(カラム名)に指定したカラム以外をふるいにかけて捨てる。
  def micropost_params
    params.require(:micropost).permit(:content)
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
      redirect_to root_url
    end
  end
end
