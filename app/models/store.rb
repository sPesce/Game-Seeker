class Store < ActiveRecord::Base

  has_many :deals
  has_many :games, through: :deals   
  
end