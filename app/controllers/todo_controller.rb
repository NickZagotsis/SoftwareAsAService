class TodoController < ApplicationController
  before_action :authenticate_user!
  def index
    @todo = current_user.todos
    render json: @todo
  end
  def create
    @todo = current_user.todos.create(todo_params)
    if @todo.save
      render json: @todo, status: :created
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def show
    @todo = current_user.todos.find(params[:id])
    render json: @todo.as_json(include: :todo_items)
  end

  def update
    @todo = current_user.todos.find(params[:id])
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @todo = current_user.todos.find(params[:id])
    @todo.destroy
    head :no_content
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :description)
  end
end
