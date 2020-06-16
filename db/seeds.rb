require 'pry'
Game.destroy_all
Store.destroy_all
Deal.destroy_all
params =
{#params[store](0..2)
  store:[ {id: 1,name: "store1", api_id_store: 1},
          {id: 2, name: "gamestop", api_id_store: 2},
          {id: 3, name: "Best Buy", api_id_store: 3}
        ],  
  game: [
          {id:1,title: "war thunder", release_date: DateTime.now - 400.day, retail_price: 50.00, metacritic_score: 90, steam_app_id: 222, api_id_game: 1},
          {id:2,title: "terraria", release_date: DateTime.now - 40.day, retail_price: 45.40, metacritic_score: 40, steam_app_id: 212, api_id_game: 2},
          {id:3,title: "Hidden: Source", release_date: DateTime.now - 10.year, retail_price: 10.00, metacritic_score: 100, steam_app_id: 617,api_id_game: 3},          
          {id:4,title: "TF2", release_date: DateTime.now - 12.year, retail_price: 35.01, metacritic_score: 75, steam_app_id: 107,api_id_game: 4}          
        ]
}
#3 NEW stores
 (0..2).each{|i|Store.create(params[:store][i])}
 stores = Store.all
#3 NEW games
(0..2).each{|i|Game.create(params[:game][i])}
games = Game.all
#3 deals from games
(0..2).each{|i|Deal.create()} 
deals = Deal.all

(0..2).each do |i|
  deals[i].game = games[i]
  deals[i].store = stores[i]
  deals[i].save
end

s = Store.create(params[:store][3])
d1 = Deal.create()
d1.game = Game.first
d1.store = Store.second
#binding.pry

deals[0].sale_price = deals[0].game.retail_price*(90.0/100.0)
deals[1].sale_price = deals[1].game.retail_price * (91.0/100.0)
deals[2].sale_price = deals[2].game.retail_price * (61.0/100.0)
deals.each{|deal|deal.save}
d1.sale_price = d1.game.retail_price * (50.0/100.0)
d1.save

