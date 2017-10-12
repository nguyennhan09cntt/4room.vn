class CreatePosts < ActiveRecord::Migration[5.0]
  def change
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
  end
end
