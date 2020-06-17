class Deal < ActiveRecord::Base

  belongs_to :game
  belongs_to :store 
 
  #as a user I want to be able to search a deal by price
  def self.max_price_filter(price)
    self.where("sale_price <= ?",price).order(sale_price: :desc)
  end

  
  
  # #as a user I want to find the highest % savings deals
  # def self.highest_percentage_off(limit,duplicate == true)
  # Deal.all.each do |deal|
  #     price_reduced =  Deal.game.retail_price Deal.sale_price 
  #   end  
  # end
  
  #as a user I want to find the deals on n highest-rated games
  def self.get_best_deals(limit = 5)
    #find highest n(#) rated games
    highest_rated = Game.order(metacritic_score: :desc).limit(limit)
    ids = highest_rated.map{|game|game.id}    
    #find lowest sale price for each game
    deals = []
    ids.each{|id|deals << Deal.where(game_id: id).order(sale_price: :asc).first}  
    deals  
  end

    
  #TODO make join table for savings, 
  #retail_price
  #deal_price
  #can we join without using primary keys?
  #or should we add original price to deals table?
  
end
