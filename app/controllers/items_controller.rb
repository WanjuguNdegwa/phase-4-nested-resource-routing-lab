class ItemsController < ApplicationController

  def index
    if params[:user_id]
      user = User.find_by(id: params[:user_id])

      if user
        render json: user.items
      else
        render json: { error: "User not found" }, status: :not_found
      end
    else
      render json: Item.all, include: :user
    end
  end

  def show
    item = Item.find_by(id: params[:id])

    if item
      render json: item
    else
      render json: { error: "Item not found" }, status: :not_found
    end

  end

  def create
    item = Item.new(item_params)
    user = User.find_by(id: params[:user_id])

    if user
      item.user = user
    else
      return render json: { error: "User not found" }, status: :not_found
    end

    if item.save
      render json: item, status: :created
    else
      render json: item.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.permit(:name, :description, :price)
  end

end
