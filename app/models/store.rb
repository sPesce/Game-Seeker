class Store < ActiveRecord::Base

  has_many :deals
  has_many :games, through: :deals 

   
  #as a user I want to find the cheapest deal through store
  
end