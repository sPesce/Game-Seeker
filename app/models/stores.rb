class Store

    attr_accessor :id, :name

    @@all = []

    def initialize(id, name)
        @id = id
        @name = name
        @@all << self
    end

    def self.all
        @@all
    end

    #all the deals this store currently offers
    def deals

    end

    ##all the games this store currently has on sale
    def games
    end


end