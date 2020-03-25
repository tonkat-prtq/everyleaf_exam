class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :admin_check
  
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  def show

  end

  def edit

  end

  def update
    if params[:back]
      render :edit
    else
      if @user.update(user_params)
        redirect_to user_path(@user.id), flash: {success: "ユーザー情報を更新しました"}
      else
        render :edit
      end
    end
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def admin_check
    if current_user.admin
    else
      redirect_to user_path(current_user.id)
    end
  end
end
