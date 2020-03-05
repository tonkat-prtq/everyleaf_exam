class TasksController < ApplicationController
  before_action :set_task, only: %i(show edit update destroy) 
  def index
    @tasks = Task.all.order(created_at: "DESC")
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
    params.require(:task).permit(:name, :content)
  end
end
