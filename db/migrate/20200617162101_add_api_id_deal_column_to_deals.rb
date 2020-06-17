class AddApiIdDealColumnToDeals < ActiveRecord::Migration[6.0]
  def change
    add_column :deals, :api_id_deals, :string
  end
end
