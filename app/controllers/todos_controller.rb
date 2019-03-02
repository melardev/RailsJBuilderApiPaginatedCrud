class TodosController < ApplicationController
  before_action :set_page, only: [:index, :get_pending, :get_completed]
  before_action :set_todo, only: [:show, :update, :destroy]

  # GET /todos
  def index
    set_todo_list Todo
    render :list
  end

  def get_pending
    set_todo_list Todo.where(completed: false)
    render :list
  end

  def get_completed
    set_todo_list Todo.where(completed: true)
    render :list
  end

  # GET /todos/1
  def show
    render :show
  end

  # POST /todos
  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      @messages = ['Todo updated successfully']
      render 'todos/show'
    else
      @success = false
      @messages = ['An error occurred']
      render 'shared/messages'
    end
  end

  # PATCH/PUT /todos/1
  def update
    if @todo.update(todo_params)
      @messages = ['Todo updated successfully']
      render 'todos/show'
    else
      # TODO: give a more meaningful error message, @todo.errors
      @success = false
      @messages = ['An error occurred']
      render 'shared/messages'
    end
  end

  # DELETE /todos/1
  def destroy
    @todo.destroy
    @success = true
    @messages = ['Deleted todo successfully']
    render 'shared/messages'
  end

  def destroy_all
    # delete_all vs destroy_all? delete skips callbacks, destroy does execute them
    Todo.destroy_all
    @success = true
    @messages = ['Deleted all todos successfully']
    render 'shared/messages'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_todo
    @todo = Todo.find(params[:id])
  end

  def set_todo_list query
    @todos = query.order(created_at: :desc).offset(@offset).limit(@page_size).select("id, title,completed, created_at, updated_at")
    @todos_count = query.count
    @page_meta = PageMeta.new(@todos, @todos_count, self.request.path, @page, @page_size)
  end

  def set_page
    @page = params[:page] || 1
    @page_size = params[:page_size] || 8
    @offset = @page_size * (@page - 1)
  end

  # Only allow a trusted parameter "white list" through.
  def todo_params
    params.permit(:title, :description, :completed)
  end
end
