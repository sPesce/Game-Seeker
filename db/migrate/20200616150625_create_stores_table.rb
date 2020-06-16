class CreateStoresTable < ActiveRecord::Migration[6.0]
  def change
    create_table do |t|
      t.integer  :id
      t.string   :name
    end 
  end
end
