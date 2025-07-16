ActiveRecord::Schema[7.2].define(version: 2025_04_08_153545) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cars", force: :cascade do |t|
    t.string "model", null: false
    t.integer "power", null: false
    t.integer "weight", null: false
    t.integer "fuel_capacity", null: false
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "races", force: :cascade do |t|
    t.bigint "car_id", null: false
    t.bigint "track_id", null: false
    t.integer "total_laps"
    t.float "fuel_consumption_per_lap", null: false
    t.float "average_lap_time", null: false
    t.float "total_fuel_needed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "car_name"
    t.string "car_category"
    t.string "track_name"
    t.integer "race_time_minutes", null: false
    t.boolean "mandatory_pit_stop", default: false
    t.integer "planned_pit_stops", null: false
    t.index ["car_id"], name: "index_races_on_car_id"
    t.index ["track_id"], name: "index_races_on_track_id"
    t.index ["user_id"], name: "index_races_on_user_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "name", null: false
    t.float "distance", null: false
    t.integer "number_of_curves", null: false
    t.string "country", null: false
    t.integer "elevation_track", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.boolean "admin", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "races", "cars"
  add_foreign_key "races", "tracks"
  add_foreign_key "races", "users"
end
