class SessionsController < ApplicationController
  skip_before_action :login_required
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) # User.find_byで、送られてきたパラメータのemailでuserテーブルのemailカラムを検索し最初に見つけた値を返す
    if user && user.authenticate(params[:session][:password]) # パスワードが一致しているかの判定
      session[:user_id] = user.id # これでログインができる
      redirect_to user_path(user.id), flash: {success: t('.notice')}
    else
      flash.now[:danger] = t('.danger')
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path, flash: {success: t('.notice')}
  end
end
