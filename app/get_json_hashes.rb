  class GetJsonHashes
    
    URL = 'https://www.cheapshark.com/api/1.0/'
    
    def self.populate_tables
      store_result = RestClient.get("#{URL}stores")
      store_hashes = JSON.parse(store_result)

      store_hashes.each do |s|
        store_params = 
        {
          api_id_store: s['storeID'],
          name:         s['storeName']
        }
        store = Store.find_by(api_id_store: s['storeID'])
        if store == nil
          store = Store.create(store_params)
        end        
      end
      #----------------------------------------
      deal_game = RestClient.get("#{URL}deals")
      deal_game_hashes = JSON.parse(deal_game)
      #deals and games
      deal_game_hashes.each do |r|        
        #deal store_id        
        game_params = 
        {
          title:            r['title'],
          api_id_game:      r['gameID'],
          release_date:     r['releaseDate'],
          metacritic_score: r['metacriticScore'],
          retail_price:     r['normalPrice'],
          steam_app_id:     r['steamAppID']              
        }
        deal_params =
        {
          api_id_deals: r['dealID'],
          sale_price:   r['salePrice']
        }
        deals_sale_price = r['salePrice']          
        game = Game.find_by(api_id_game: r['gameID'])
        if game == nil
          game = Game.create(game_params)
        elsif game.retail_price != r['normalPrice']  
          game.retail_price = r['normalPrice']
          game.save
        end
        deal = Deal.find_by(api_id_deals: r['dealID'])
        if deal == nil
          deal = Deal.create(deal_params)
          deal.game = game
          deal.store = Store.find_by(api_id_store: r['storeID'])
          deal.save
        end        
      end

    end
    
  end#====================================================================>
