class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_check
  PER = 5

  def index
    @users = User.includes(:tasks)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, flash: {success: "ユーザーを作成しました"}
    else
      render :new
    end
  end

  def show
    @user_tasks = @user.tasks.page(params[:page]).per(PER).default_order
  end

  def edit

  end

  def update
    if params[:back]
      render :edit
    else
      if @user.update(user_params)
        redirect_to admin_users_path, flash: {success: "ユーザー情報を更新しました"}
      else
        render :edit
      end
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, flash: {danger: "ユーザーを削除しました"}
  end

  private

  def user_params
    params.require(:user).permit(:id, :name, :email, :admin, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def admin_check
    if current_user.admin
    else
      redirect_to root_path, flash: {danger: "あなたは管理者ではありません"}
    end
  end
end
