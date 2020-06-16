class CreateDealsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :deals do |t|
      #t.integer  :id
      t.integer :store_id
      t.integer :game_id
      t.decimal :sale_price  
    end
  end
end
