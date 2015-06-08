require 'delegate'
class BaseService < SimpleDelegator
  def clearance_items!
    if clearancing_status.item_ids_to_clearance.any? 
      clearancing_status.clearance_batch.save!
      clearancing_status.item_ids_to_clearance.each do |item_id|
        item = Item.find(item_id)
        item.clearance!
        clearancing_status.clearance_batch.items << item
      end
    end
    clearancing_status
  end
end
