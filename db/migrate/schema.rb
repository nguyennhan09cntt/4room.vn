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

ActiveRecord::Schema.define(version: 20170921141234) do

  create_table "category", force: :cascade, options: " DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       limit: 128
    t.string   "identify",   limit: 128
    t.integer  "parent_id"
    t.datetime "created_at"
    t.index ["identify"], name: "identify_UNIQUE", unique: true, using: :btree
  end

  create_table "config_status", force: :cascade, options: " DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       limit: 128
    t.datetime "created_at"
  end

  create_table "member", force: :cascade, options: " DEFAULT CHARSET=utf8" do |t|
    t.string   "name",          limit: 256
    t.string   "facebook_id",   limit: 128
    t.string   "cover",         limit: 256
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "administrator", limit: 1
    t.index ["facebook_id"], name: "index2", unique: true, using: :btree
  end

  create_table "post", force: :cascade, options: " DEFAULT CHARSET=utf8" do |t|
    t.string   "name",        limit: 128
    t.text     "content",     limit: 16777215,                                      collation: "utf8mb4_general_ci"
    t.string   "description", limit: 512
    t.string   "price",       limit: 45
    t.integer  "site_id"
    t.string   "address",     limit: 256
    t.string   "facebook_id", limit: 45
    t.string   "owner_name",  limit: 256
    t.string   "owner_phone", limit: 45
    t.string   "member_id",   limit: 45
    t.integer  "status",      limit: 1,        default: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "import_at",                    default: -> { "CURRENT_TIMESTAMP" }
  end

  create_table "post_image", force: :cascade, options: " DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       limit: 128
    t.string   "post_id",    limit: 45
    t.string   "url",        limit: 256
    t.datetime "created_at"
    t.string   "update_at",  limit: 45
  end

  create_table "site", force: :cascade, options: " DEFAULT CHARSET=utf8" do |t|
    t.string   "name",          limit: 128
    t.string   "url",           limit: 128
    t.string   "facebook_id",   limit: 45
    t.string   "cover",         limit: 256
    t.integer  "category_id",                 default: 6, null: false
    t.text     "description",   limit: 65535
    t.integer  "member_count"
    t.datetime "created_at"
    t.integer  "import_post",   limit: 1
    t.integer  "import_member", limit: 1
  end

  create_table "site_category", force: :cascade, options: " DEFAULT CHARSET=utf8" do |t|
    t.integer "site_id"
    t.integer "category_id"
  end

  create_table "site_member", force: :cascade, options: " DEFAULT CHARSET=utf8" do |t|
    t.integer  "site_id",    null: false
    t.integer  "member_id",  null: false
    t.datetime "created_at"
    t.index ["site_id", "member_id"], name: "index2", unique: true, using: :btree
  end

  create_table "user", force: :cascade, options: " DEFAULT CHARSET=utf8", comment: "Table account" do |t|
    t.string   "user_name",    limit: 128,             null: false
    t.string   "password",     limit: 128
    t.string   "name",         limit: 128
    t.date     "birthday"
    t.datetime "joined_at"
    t.string   "salt",         limit: 128
    t.string   "last_login",   limit: 45
    t.integer  "level",        limit: 1
    t.integer  "manager_id"
    t.integer  "status",       limit: 1,   default: 0
    t.string   "job",          limit: 256
    t.string   "phone",        limit: 45
    t.integer  "fk_user_role",             default: 2
    t.string   "session_id",   limit: 128
    t.string   "facebook_id",  limit: 128
    t.string   "email",        limit: 256
    t.string   "access_token", limit: 256
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_name"], name: "user_name_UNIQUE", unique: true, using: :btree
  end

  create_table "user_acl", unsigned: true, force: :cascade, options: " DEFAULT CHARSET=utf8" do |t|
    t.integer  "fk_user_role",      null: false, unsigned: true
    t.integer  "fk_user_privilege", null: false, unsigned: true
    t.datetime "created_at"
  end

  create_table "user_component", force: :cascade, options: " DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci" do |t|
    t.string   "name"
    t.datetime "created_at", comment: "Component"
  end

  create_table "user_module", unsigned: true, force: :cascade, options: " DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci" do |t|
    t.string   "name"
    t.integer  "fk_user_component",           null: false,                    unsigned: true
    t.integer  "priority",          limit: 1
    t.datetime "created_at",                               comment: "module"
  end

  create_table "user_permission", unsigned: true, force: :cascade, options: " DEFAULT CHARSET=utf8" do |t|
    t.integer  "fk_user",           null: false, unsigned: true
    t.integer  "fk_user_privilege", null: false, unsigned: true
    t.datetime "created_at"
  end

  create_table "user_privilege", unsigned: true, force: :cascade, options: " DEFAULT CHARSET=utf8" do |t|
    t.integer  "fk_user_resource",                         null: false, unsigned: true
    t.string   "name",             limit: 127,             null: false
    t.string   "action",           limit: 127
    t.integer  "active",           limit: 1,   default: 1
    t.integer  "priority",         limit: 1
    t.integer  "display",          limit: 1,   default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_resource", unsigned: true, force: :cascade, options: " DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci" do |t|
    t.string   "name",           limit: 45
    t.string   "controller",                             collation: "utf8_general_ci"
    t.integer  "active",         limit: 1
    t.integer  "display",        limit: 1
    t.integer  "priority",       limit: 1
    t.integer  "fk_user_module",            null: false,                               comment: "Resource"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_role", unsigned: true, force: :cascade, options: " DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       limit: 256, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_site", force: :cascade, options: " DEFAULT CHARSET=utf8" do |t|
    t.integer "site_id"
    t.integer "user_id"
  end

end
