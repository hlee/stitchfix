class ItemsController < ApplicationController
  def index
    @items = case params[:sort_by]
             when "status"
               Item.order(:status).all
             when "clearance"
               Item.order(:clearance_batch_id).all
             else
               Item.all
             end
  end
end
