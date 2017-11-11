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

  create_table "post", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",             limit: 128
    t.text     "content",          limit: 16777215
    t.string   "description",      limit: 512
    t.string   "price",            limit: 45
    t.integer  "site_id"
    t.string   "facebook_id",      limit: 45
    t.string   "user_facebook_id", limit: 45
    t.string   "user_id",          limit: 45
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_image", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name",    limit: 128
    t.string "post_id", limit: 45
  end

  create_table "site", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name",        limit: 128
    t.string "url",         limit: 128
    t.string "facebook_id", limit: 45
  end

  create_table "user", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "Table account" do |t|
    t.string   "user_name",    limit: 24,              null: false
    t.string   "password",     limit: 128,             null: false
    t.string   "name",         limit: 128
    t.date     "birthday"
    t.datetime "joined_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt",         limit: 128
    t.string   "last_login",   limit: 45
    t.integer  "level",        limit: 1
    t.integer  "manager_id"
    t.integer  "status",       limit: 1,   default: 0
    t.string   "job",          limit: 256
    t.string   "phone",        limit: 45
    t.integer  "fk_user_role"
    t.string   "session_id",   limit: 128
    t.index ["user_name"], name: "user_name_UNIQUE", unique: true, using: :btree
  end

  create_table "user_acl", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "fk_user_role",      null: false, unsigned: true
    t.integer  "fk_user_privilege", null: false, unsigned: true
    t.datetime "created_at"
  end

  create_table "user_component", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci" do |t|
    t.string   "name"
    t.datetime "created_at", comment: "Component"
  end

  create_table "user_module", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci" do |t|
    t.string   "name"
    t.integer  "fk_user_component",           null: false,                    unsigned: true
    t.integer  "priority",          limit: 1
    t.datetime "created_at",                               comment: "module"
  end

  create_table "user_permission", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "fk_user",           null: false, unsigned: true
    t.integer  "fk_user_privilege", null: false, unsigned: true
    t.datetime "created_at"
  end

  create_table "user_privilege", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "fk_user_resource",                         null: false, unsigned: true
    t.string   "name",             limit: 127,             null: false
    t.string   "action",           limit: 127
    t.integer  "active",           limit: 1,   default: 1
    t.integer  "priority",         limit: 1
    t.integer  "display",          limit: 1,   default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_resource", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci" do |t|
    t.string   "name",           limit: 45
    t.string   "controller",                             collation: "utf8_general_ci"
    t.integer  "active",         limit: 1
    t.integer  "display",        limit: 1
    t.integer  "priority",       limit: 1
    t.integer  "fk_user_module",            null: false,                               comment: "Resource"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_role", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       limit: 256, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
