# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_17_162101) do

  create_table "deals", force: :cascade do |t|
    t.integer "store_id"
    t.integer "game_id"
    t.decimal "sale_price"
    t.string "api_id_deals"
  end

  create_table "games", force: :cascade do |t|
    t.string "title"
    t.datetime "release_date"
    t.decimal "retail_price"
    t.integer "metacritic_score"
    t.integer "steam_app_id"
    t.integer "api_id_game"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.integer "api_id_store"
  end

end
