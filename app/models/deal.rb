class Deal < ActiveRecord::Base

  belongs_to :game
  belongs_to :store 
 
  #as a user I want to be able to search a deal by price
  def self.clamp_price(price)
    self.where("sale_price BETWEEN #{price[0]} AND #{price[1]}").order(sale_price: :desc)
  end
  
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

  def mk_hyperlink
    return TTY::Link.link_to("#{self.store.name} - #{self.game.title}", "https://www.cheapshark.com/redirect?dealID=#{self.api_id_deals}")
  end  
end
