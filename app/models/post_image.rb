class PostImage < ApplicationRecord
  self.table_name = "post_image"
   belongs_to :post, foreign_key: 'post_id'
end
