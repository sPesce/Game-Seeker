  class GetJsonHashes
    
    URL = 'https://www.cheapshark.com/api/1.0/'

    def self.populate_tables
      populate_from_stores
      populate_from_deals
    end

    private#-----------------------------------------------    
    def self.populate_from_stores      
      store_hashes = get_json_hash("stores")
  
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
    end

    def self.populate_from_deals     
      deal_game_hashes = get_json_hash("deals")
      #deals and games
      deal_game_hashes.each do |r|        
        #deal store_id        
        game_params = json_to_game_params(r)
        deal_params = json_to_deal_params(r)
        
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
    def self.get_json_hash(page)
      result = RestClient.get("#{URL}#{page}")
      return JSON.parse(result)
    end

    def self.json_to_game_params(j_hash)      
      {
        title:            j_hash['title'],
        api_id_game:      j_hash['gameID'],
        release_date:     j_hash['releaseDate'],
        metacritic_score: j_hash['metacriticScore'],
        retail_price:     j_hash['normalPrice'],
        steam_app_id:     j_hash['steamAppID']              
      }
    end

    def self.json_to_deal_params(j_hash)
      {
        api_id_deals: j_hash['dealID'],
        sale_price:   j_hash['salePrice']
      }
    end
    
  end#====================================================================>
