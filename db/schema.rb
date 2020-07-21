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

ActiveRecord::Schema.define(version: 2020_07_20_215459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.index ["manager_id"], name: "index_employees_on_manager_id"
    t.index ["organization_id"], name: "index_employees_on_organization_id"
  end

  create_table "employees_skills", id: false, force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "skill_id"
    t.index ["employee_id"], name: "index_employees_skills_on_employee_id"
    t.index ["skill_id"], name: "index_employees_skills_on_skill_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "website"
    t.string "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string "description"
    t.bigint "employee_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id"], name: "index_reviews_on_employee_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "slack_teams", force: :cascade do |t|
    t.string "slack_id"
    t.string "name"
    t.bigint "organization_id", null: false
    t.index ["organization_id"], name: "index_slack_teams_on_organization_id"
  end

  add_foreign_key "employees", "employees", column: "manager_id"
  add_foreign_key "employees", "organizations"
  add_foreign_key "reviews", "employees"
  add_foreign_key "slack_teams", "organizations"
end
