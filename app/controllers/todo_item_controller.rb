class TodoItemController < ApplicationController
  before_action :authenticate_user!

  def show
    @todo_item = current_user.todos.find(params[:todo_id]).todo_items.find(params[:id])
    render json: @todo_item
  end

  def create
    @todo = current_user.todos.find(params[:todo_id])
    @todo_item = @todo.todo_items.create(todo_item_params)
    if @todo_item.save
      render json: @todo_item, status: :created
    else
      render json: @todo_item.errors, status: :unprocessable_entity
    end
  end

  def update
    @todo_item = current_user.todos.find(params[:todo_id]).todo_items.find(params[:id])
    if @todo_item.update(todo_item_params)
      render json: @todo_item
    else
      render json: @todo_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @todo_item = current_user.todos.find(params[:todo_id]).todo_items.find(params[:id])
    @todo_item.destroy
    head :no_content
  end

  private

  def todo_item_params
    params.require(:todo_item).permit(:content, :completed)
  end
end
