class TasksController < ApplicationController
  before_action :set_task, only: %i(show edit update destroy) 
  def index
    if params[:sort]
      @tasks = Task.all.order(params[:sort])
    else
      @tasks = Task.all.order(created_at: "DESC")
    end
    if params[:search]
      if params[:name].empty? && params[:status].empty?
        @tasks = Task.all
      elsif params[:name].empty? && params[:status]
        @tasks = Task.where('status = ?', "#{params[:status]}")
      elsif params[:name] && params[:status].empty?
        @tasks = Task.where('name LIKE ?', "%#{params[:name]}%")
      else
        @tasks = Task.where("name LIKE ? and status = ?", "%#{params[:name]}%", "#{params[:status]}")
        puts "ここだよ"
      end
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to task_path(@task.id), flash: {success: "タスクを登録しました"}
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
      if @task.update(task_params)
        redirect_to root_path, flash: {success: "タスクを編集しました"}
      else
        render :edit
      end
    end
  end

  def destroy
    @task.destroy
    redirect_to root_path, flash: {danger: "タスクを削除しました"}
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :content, :deadline, :status)
  end
end
