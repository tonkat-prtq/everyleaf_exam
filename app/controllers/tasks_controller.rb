class TasksController < ApplicationController
  before_action :set_task, only: %i(show edit update destroy) 
  PER = 5
  def index
    @tasks = current_user.tasks
    
    @tasks = @tasks
    .search_with_name(params[:name])
    .search_with_status(params[:status])

    # 検索のコードを上に持ってきてしまうと予期せぬ動作になるかと思ったが、メソッドが引数を受け取らない限りreturnされるコードなので問題がない

    if params[:sort]
      @tasks = @tasks.page(params[:page]).per(PER).order(params[:sort])
    else
      @tasks = @tasks.page(params[:page]).per(PER).default_order
    end

    # if params[:search]
    #   if params[:name].empty? && params[:status].empty?
    #     @tasks = Task.all
    #   elsif params[:name].empty? && params[:status]
    #     @tasks = Task.where('status = ?', "#{params[:status]}")
    #   elsif params[:name] && params[:status].empty?
    #     @tasks = Task.where('name LIKE ?', "%#{params[:name]}%")
    #   else
    #     @tasks = Task.where("name LIKE ? and status = ?", "%#{params[:name]}%", "#{params[:status]}")
    #   end
    # end

  end

  def new
    if params[:back]
      @task = current_user.tasks.build(task_params)
      render :new
    else
      @task = Task.new
    end
  end

  def create
    @task = current_user.tasks.build(task_params)
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
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :content, :deadline, :status, :priority)
  end
end
