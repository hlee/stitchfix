class Item < ActiveRecord::Base
  include AASM

  CLEARANCE_PRICE_PERCENTAGE  = BigDecimal.new("0.75")

  belongs_to :style
  belongs_to :clearance_batch
  validates :size, presence: true

  delegate :type, :name, :min_sale_price, :wholesale_price, :retail_price, to: :style, prefix: true

  scope :sellable, -> { where(status: 'sellable') }
  scope :sort_by, -> (term) {order(term.to_sym) if term.present? }

  def update_sold_price
    price_sold = style.wholesale_price * CLEARANCE_PRICE_PERCENTAGE
    if ["Pants", "Dress"].include?(style.type) and price_sold < 5
      price_sold = 5
    elsif price_sold < 2
      price_sold = 2
    end
    self.update(price_sold: price_sold, sold_at: Time.now)
  end

  aasm :column => :status do
    state :sellable, :initial => true
    state :not_sellable
    state :sold
    state :clearanced

    event :clearance, after: :update_sold_price do
      transitions :from => :sellable, :to => :clearanced
    end

    event :restock do
      transitions :from => [:clearanced, :sold], :to => :sellable
    end

    event :sell do
      transitions :from => :sellable, :to => :sold
    end
  end
end
