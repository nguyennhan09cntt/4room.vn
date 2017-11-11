class UserResource < ApplicationRecord
	self.table_name = "user_resource"
	belongs_to :user_module, foreign_key: 'fk_user_module'
	has_many :user_privilege
end
