class Game < ActiveRecord::Base

  has_many :deals
  has_many :stores, through: :deals 

   #find cheapest deal for this game
   def cheapest_deal
    self.deals.order(sale_price: :asc).limit(1).first
   end
end