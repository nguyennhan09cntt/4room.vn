class UserComponent < ApplicationRecord
	self.table_name = "user_component"
	has_many :user_module
end