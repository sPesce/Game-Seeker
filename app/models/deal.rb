class Deal < ActiveRecord::Base

  belongs_to :game
  belongs_to :store 
 
  #
  def self.best_deal_rating
  end

end

