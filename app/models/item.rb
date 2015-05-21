class Item < ActiveRecord::Base

  CLEARANCE_PRICE_PERCENTAGE  = BigDecimal.new("0.75")

  belongs_to :style
  belongs_to :clearance_batch
  validates :size, presence: true

  scope :sellable, -> { where(status: 'sellable') }
  scope :sort_by, -> (term) {order(term.to_sym) if term.present? }

  def clearance!
    price_sold = style.wholesale_price * CLEARANCE_PRICE_PERCENTAGE
    if ["Pants", "Dress"].include?(style.type) and price_sold < 5
      price_sold = 5
    elsif price_sold < 2
      price_sold = 2
    end

    update_attributes!(status: 'clearanced', 
                       price_sold: price_sold)
  end

end
