class RemoveAutoIncrementIdGamesDealsStores < ActiveRecord::Migration[6.0]
  def change
    change_column :stores, :id, :integer
    change_column :games, :id, :integer
    change_column :deals, :id, :string
  end
end
