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

ActiveRecord::Schema.define(version: 2020_12_28_154130) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "colonies", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_colonies_on_user_id"
  end

  create_table "colony_components", force: :cascade do |t|
    t.boolean "researched", default: false
    t.bigint "colony_id"
    t.bigint "component_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["colony_id", "component_id"], name: "index_colony_components_on_colony_id_and_component_id", unique: true
    t.index ["colony_id"], name: "index_colony_components_on_colony_id"
    t.index ["component_id"], name: "index_colony_components_on_component_id"
  end

  create_table "component_resources", force: :cascade do |t|
    t.integer "amount", default: 0
    t.bigint "component_id"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["component_id", "resource_id"], name: "index_component_resources_on_component_id_and_resource_id", unique: true
    t.index ["component_id"], name: "index_component_resources_on_component_id"
    t.index ["resource_id"], name: "index_component_resources_on_resource_id"
  end

  create_table "components", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "research_cost", default: 2000
    t.integer "build_cost", default: 500
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "inventory_components", force: :cascade do |t|
    t.integer "amount", default: 0
    t.bigint "inventory_id"
    t.bigint "component_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["component_id"], name: "index_inventory_components_on_component_id"
    t.index ["inventory_id", "component_id"], name: "index_inventory_components_on_inventory_id_and_component_id", unique: true
    t.index ["inventory_id"], name: "index_inventory_components_on_inventory_id"
  end

  create_table "inventory_resources", force: :cascade do |t|
    t.integer "amount", default: 0
    t.bigint "inventory_id"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["inventory_id", "resource_id"], name: "index_inventory_resources_on_inventory_id_and_resource_id", unique: true
    t.index ["inventory_id"], name: "index_inventory_resources_on_inventory_id"
    t.index ["resource_id"], name: "index_inventory_resources_on_resource_id"
  end

  create_table "inventory_ships", force: :cascade do |t|
    t.integer "amount", default: 0
    t.bigint "inventory_id"
    t.bigint "ship_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["inventory_id", "ship_id"], name: "index_inventory_ships_on_inventory_id_and_ship_id", unique: true
    t.index ["inventory_id"], name: "index_inventory_ships_on_inventory_id"
    t.index ["ship_id"], name: "index_inventory_ships_on_ship_id"
  end

  create_table "mine_upgrades", force: :cascade do |t|
    t.boolean "bought", default: false
    t.bigint "upgrade_id"
    t.bigint "mine_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mine_id", "upgrade_id"], name: "index_mine_upgrades_on_mine_id_and_upgrade_id", unique: true
    t.index ["mine_id"], name: "index_mine_upgrades_on_mine_id"
    t.index ["upgrade_id"], name: "index_mine_upgrades_on_upgrade_id"
  end

  create_table "mines", force: :cascade do |t|
    t.string "name"
    t.integer "uraniumCost", default: 50
    t.integer "energy", default: 0
    t.integer "energyCap", default: 100
    t.integer "multiplier", default: 1
    t.bigint "user_id"
    t.bigint "resource_id"
    t.bigint "inventory_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["inventory_id"], name: "index_mines_on_inventory_id"
    t.index ["resource_id"], name: "index_mines_on_resource_id"
    t.index ["user_id"], name: "index_mines_on_user_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ship_components", force: :cascade do |t|
    t.integer "amount", default: 1
    t.bigint "ship_id"
    t.bigint "component_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["component_id"], name: "index_ship_components_on_component_id"
    t.index ["ship_id", "component_id"], name: "index_ship_components_on_ship_id_and_component_id", unique: true
    t.index ["ship_id"], name: "index_ship_components_on_ship_id"
  end

  create_table "ships", force: :cascade do |t|
    t.string "name"
    t.integer "research_cost", default: 2000
    t.integer "build_cost", default: 500
    t.integer "build_time", default: 60
    t.integer "carry_capacity", default: 100
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "spaceport_ships", force: :cascade do |t|
    t.boolean "researched", default: false
    t.bigint "spaceport_id"
    t.bigint "ship_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ship_id"], name: "index_spaceport_ships_on_ship_id"
    t.index ["spaceport_id", "ship_id"], name: "index_spaceport_ships_on_spaceport_id_and_ship_id", unique: true
    t.index ["spaceport_id"], name: "index_spaceport_ships_on_spaceport_id"
  end

  create_table "spaceports", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_spaceports_on_user_id"
  end

  create_table "types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "upgrades", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "cost"
    t.integer "value"
    t.bigint "type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["type_id"], name: "index_upgrades_on_type_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.float "balance", default: 0.0
    t.bigint "inventory_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["inventory_id"], name: "index_users_on_inventory_id"
  end

end
