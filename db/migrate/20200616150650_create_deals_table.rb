class CreateDealsTable < ActiveRecord::Migration[6.0]
  def change
    def create_table |t| do
      t.string  :id
      t.integer :store_id
      t.integer :game_id
      t.decimal :sale_price
      t.boolean :is_on_sale      
    end
  end
end
