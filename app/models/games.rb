class Game < ActiveRecord::Base

    has_many :deals
    has_many :stores, through: :deals 

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

     #all the deals this game is offered 
     def deals

     end
 
     ##all the stores this game currently is on sale at
     def stores
     end

end