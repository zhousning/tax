# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181011142224) do

  create_table "buyers", force: :cascade do |t|
    t.string   "alias",          default: "", null: false
    t.string   "name",           default: "", null: false
    t.string   "duty_paragraph", default: "", null: false
    t.string   "account",        default: "", null: false
    t.string   "phone",          default: "", null: false
    t.string   "remark",         default: "", null: false
    t.string   "checker",        default: "", null: false
    t.string   "payee",          default: "", null: false
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.string   "standard",         default: "",  null: false
    t.string   "unit",             default: "",  null: false
    t.float    "amount",           default: 0.0, null: false
    t.float    "tax_unit_price",   default: 0.0, null: false
    t.float    "tax_total",        default: 0.0, null: false
    t.float    "cess",             default: 0.0, null: false
    t.float    "untax_unit_price", default: 0.0, null: false
    t.float    "untax_total",      default: 0.0, null: false
    t.float    "tax_money",        default: 0.0, null: false
    t.integer  "tax_category_id"
    t.integer  "buyer_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "name"
    t.string   "subject_class"
    t.integer  "subject_id"
    t.string   "action"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "role_permissionships", force: :cascade do |t|
    t.integer  "role_id"
    t.integer  "permission_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "system_infos", force: :cascade do |t|
    t.string   "version",              default: "2.0",  null: false
    t.string   "national_tax_version", default: "3.0",  null: false
    t.string   "tax_category_version", default: "30.0", null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "tax_categories", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.string   "code",       default: "", null: false
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "role_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
