require 'rails_helper'

describe Item do
  it { should belong_to :style }
  it { should belong_to :clearance_batch }
  it { should validate_presence_of :size }

  context "delegate" do
    let(:style) { FactoryGirl.create(:style, wholesale_price: 100) }
    let(:item) { FactoryGirl.create(:item, style: style, status: "sellable") }

    it "should eq style type" do
      expect(item.style_type).to eq style.type
    end

    it "should eq style name" do
      expect(item.style_name).to eq style.name
    end

    it "should eq style min_sale_price" do
      expect(item.style_min_sale_price).to eq style.min_sale_price
    end

    it "should eq style wholesale_price" do
      expect(item.style_wholesale_price).to eq style.wholesale_price
    end

    it "should eq style retail_price" do
      expect(item.style_retail_price).to eq style.retail_price
    end
  end

  describe "#perform_clearance!" do
    let(:wholesale_price) { 100 }
    let(:item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style, wholesale_price: wholesale_price), status: "sellable") }
    before do
      item.clearance!
      item.reload
    end

    it "should mark the item status as clearanced" do
      expect(item.status).to eq("clearanced")
    end

    it "should set the price_sold as 75% of the wholesale_price" do
      expect(item.price_sold).to eq(BigDecimal.new(wholesale_price) * BigDecimal.new("0.75"))
    end
  end

  context "aasm" do
    let(:style) { FactoryGirl.create(:style, wholesale_price: 100) }
    let(:item) { FactoryGirl.create(:item, style: style, status: "sellable") }

    it "should clearanced" do
      item.clearance!
      item.reload
      expect(item.price_sold).to eq BigDecimal.new(100) * BigDecimal.new("0.75")
      expect(item.clearanced?).to eq true
    end

    it "should sold" do
      item.sell!
      item.reload
      expect(item.sold?).to eq true
    end

    it "should sellable" do
      item.sell!
      item.restock!
      item.reload
      expect(item.sellable?).to eq true
    end
  end
end
