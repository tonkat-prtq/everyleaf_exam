class TasksController < ApplicationController
  before_action :set_task, only: %i(show) 
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to root_path, flash: {success: "タスクを登録しました"}
    else
      render :new
    end
  end

  def show
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :content)
  end
end
