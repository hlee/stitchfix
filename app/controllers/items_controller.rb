class ItemsController < ApplicationController
  def index
    @items = Item.sort_by(params[:sort_by])
  end
end
