class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_user # 現在ログインしているユーザーが管理者でなければ、root_pathへリダイレクト
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
      redirect_to admin_users_path, flash: {success: t('.notice')}
    else
      render :new
    end
  end

  def show
    if params[:sort]
      @user_tasks = @user.tasks.page(params[:page]).per(PER).order(params[:sort])
    else
      @user_tasks = @user.tasks.page(params[:page]).per(PER).default_order
    end
  end

  def edit

  end

  def update
    if params[:back]
      render :edit
    else
      if @user.update(user_params)
        redirect_to admin_users_path, flash: {success: t('.notice')}
      else
        render :edit
      end
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, flash: {danger: t('.notice')}
    else
      redirect_to admin_users_path, flash: {danger: t('.danger')}
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :name, :email, :admin, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def admin_user
    redirect_to root_path, flash: {danger: t('.danger')} unless current_user.admin?
  end
end
