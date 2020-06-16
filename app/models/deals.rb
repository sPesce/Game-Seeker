class Deal

    attr_accessor :id, :name
    attr_reader :deal_price

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

end
