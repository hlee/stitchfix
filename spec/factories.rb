FactoryGirl.define do

  factory :clearance_batch do

  end

  factory :item do
    style
    color "Blue"
    size "M"
    status "sellable"
  end

  factory :style do
    wholesale_price 55
    type "Sweater"
    name "Abrianna Lightweight Knit Cardigan"
    min_sale_price 10
    retail_price 80
  end
end
