class CreateStoresTable < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      #t.integer  :id
      t.string   :name
      t.integer  :api_id_store
    end 
  end
end
