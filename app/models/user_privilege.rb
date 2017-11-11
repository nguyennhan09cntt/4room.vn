class UserPrivilege < ApplicationRecord
	self.table_name = "user_privilege"
	belongs_to :user_resource, foreign_key: 'fk_user_resource'
end