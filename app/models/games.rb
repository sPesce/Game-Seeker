class Game

    attr_accessor :id, :title

    @@all = []

    def initialize(id, title, release_date, retail_price, metacritic_score)
        @id = id
        @title = title
        @release_date = release_date
        @retail_price = retail_price
        @metacritic_score = metacritic_score
        @@all << self
    end

    def self.all
        @@all
    end

end