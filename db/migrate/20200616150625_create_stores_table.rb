class CreateStoresTable < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      #t.integer  :id
      t.string   :name
    end 
  end
end
