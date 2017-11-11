class Post < ApplicationRecord
  self.table_name = "post"
  belongs_to :member, foreign_key: 'member_id'
	has_many :post_image

  def self.to_xls(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |post|
        csv << post.attributes.values_at(*column_names)
      end
    end
  end
end
