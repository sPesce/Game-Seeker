class Deal < ActiveRecord::Base

    belongs_to :game
    belongs_to :store 

    @@all = []

    def initialize(store_id, game_id, deal_price, deal_rating)
        @store_id = store_id
        @game_id = game_id
        @deal_price = deal_price
        @deal_rating = deal_rating
        @@all << self
    end

    def self.all
        @@all
    end

    #
    def self.best_deal_rating
    end

end
