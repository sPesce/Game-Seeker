class Game < ActiveRecord::Base

  has_many :deals
  has_many :stores, through: :deals 



   ##all the stores this game currently is on sale at
   def stores
    ids = self.deals.map{|deal|deal.store_id}
    stores = []
    ids.each{|id|stores << Store.find(id)}
    stores
   end
   
   #find cheapest deal for this game
   def cheapest_deal
    self.deals.order(sale_price: :asc).limit(1)
   end
   

end