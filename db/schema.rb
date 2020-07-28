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

ActiveRecord::Schema.define(version: 2020_07_27_202307) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analysis_metadata", force: :cascade do |t|
    t.json "personalities_description", default: {}, null: false
    t.integer "openness"
    t.integer "adventurousness"
    t.integer "artistic_interests"
    t.integer "emotionality"
    t.integer "imagination"
    t.integer "intellect"
    t.integer "authority_challenging"
    t.integer "conscientiousness"
    t.integer "achievement_striving"
    t.integer "cautiousness"
    t.integer "dutifulness"
    t.integer "orderliness"
    t.integer "self_discipline"
    t.integer "self_efficacy"
    t.integer "extraversion"
    t.integer "activity_level"
    t.integer "assertiveness"
    t.integer "cheerfulness"
    t.integer "excitement_seeking"
    t.integer "outgoing"
    t.integer "gregariousness"
    t.integer "agreeableness"
    t.integer "altruism"
    t.integer "cooperation"
    t.integer "modesty"
    t.integer "uncompromising"
    t.integer "sympathy"
    t.integer "trust"
    t.integer "emotional_range"
    t.integer "fiery"
    t.integer "prone_to_worry"
    t.integer "melancholy"
    t.integer "immoderation"
    t.integer "self_consciousness"
    t.integer "susceptible_to_stress"
  end

  create_table "channels", force: :cascade do |t|
    t.bigint "slack_team_id"
    t.string "slack_id"
    t.string "name"
    t.boolean "is_general"
    t.boolean "bot_invited"
    t.string "topic"
    t.integer "num_members"
    t.index ["slack_team_id"], name: "index_channels_on_slack_team_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "job_type"
    t.string "title"
    t.bigint "organization_id"
    t.bigint "manager_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.string "password_digest"
    t.string "access_token"
    t.string "slack_id"
    t.index ["manager_id"], name: "index_employees_on_manager_id"
    t.index ["organization_id"], name: "index_employees_on_organization_id"
  end

  create_table "employees_skills", id: false, force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "skill_id"
    t.index ["employee_id"], name: "index_employees_skills_on_employee_id"
    t.index ["skill_id"], name: "index_employees_skills_on_skill_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "text"
    t.string "slack_id"
    t.string "personality"
    t.string "slack_user_id"
    t.bigint "channel_id"
    t.string "ts"
    t.index ["channel_id"], name: "index_messages_on_channel_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "website"
    t.string "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "personalities", force: :cascade do |t|
    t.bigint "channel_id"
    t.integer "openness"
    t.integer "adventurousness"
    t.integer "artistic_interests"
    t.integer "emotionality"
    t.integer "imagination"
    t.integer "intellect"
    t.integer "authority_challenging"
    t.integer "conscientiousness"
    t.integer "achievement_striving"
    t.integer "cautiousness"
    t.integer "dutifulness"
    t.integer "orderliness"
    t.integer "self_discipline"
    t.integer "self_efficacy"
    t.integer "extraversion"
    t.integer "activity_level"
    t.integer "assertiveness"
    t.integer "cheerfulness"
    t.integer "excitement_seeking"
    t.integer "outgoing"
    t.integer "gregariousness"
    t.integer "agreeableness"
    t.integer "altruism"
    t.integer "cooperation"
    t.integer "modesty"
    t.integer "uncompromising"
    t.integer "sympathy"
    t.integer "trust"
    t.integer "emotional_range"
    t.integer "fiery"
    t.integer "prone_to_worry"
    t.integer "melancholy"
    t.integer "immoderation"
    t.integer "self_consciousness"
    t.integer "susceptible_to_stress"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["channel_id"], name: "index_personalities_on_channel_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "reviewer_id"
    t.integer "reviewed_id"
    t.boolean "pending"
    t.integer "rating"
    t.string "skill"
  end

  create_table "skills", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "slack_teams", force: :cascade do |t|
    t.string "slack_id"
    t.string "name"
    t.integer "organization_id"
    t.string "bot_token"
    t.index ["organization_id"], name: "index_slack_teams_on_organization_id"
  end

  add_foreign_key "channels", "slack_teams"
  add_foreign_key "employees", "employees", column: "manager_id"
  add_foreign_key "employees", "organizations"
  add_foreign_key "messages", "channels"
  add_foreign_key "personalities", "channels"
  add_foreign_key "slack_teams", "organizations"
end
