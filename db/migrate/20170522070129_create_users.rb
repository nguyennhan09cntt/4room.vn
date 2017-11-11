class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table "user", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "Table account" do |t|
	    t.string   "user_name",  limit: 24,              null: false
	    t.string   "password",   limit: 128,             null: false
	    t.string   "name",       limit: 128
	    t.date     "birthday"
	    t.datetime "joined_at"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	    t.string   "salt",       limit: 128
	    t.string   "last_login", limit: 45
	    t.integer  "level",      limit: 1
	    t.integer  "manager_id"
	    t.integer  "status",     limit: 1,   default: 0
	    t.string   "job",        limit: 256
	    t.string   "phone",      limit: 45
	    t.index ["user_name"], name: "user_name_UNIQUE", unique: true, using: :btree
	  end
  end
end
