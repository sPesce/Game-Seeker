class Game < ActiveRecord::Base

  has_many :deals
  has_many :stores, through: :deals 

   #all the deals this game is offered 
   def deals
   end

   ##all the stores this game currently is on sale at
   def stores
   end

end