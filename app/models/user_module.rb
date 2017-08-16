class UserModule < ApplicationRecord
	self.table_name = "user_module"
	has_many :user_resource

	def self.get_all_privilege
		query = "
			SELECT 
				user_module.*,
				user_resource.id  AS resource_id,
				user_resource.name AS resource_name,
				user_privilege.id AS privilege_id,
			    user_privilege.name AS privilege_name
			FROM 
				user_module
			LEFT JOIN 
				user_resource ON user_resource.fk_user_module = user_module.id
			LEFT JOIN
				user_privilege ON user_privilege.fk_user_resource = user_resource.id
			WHERE 
				user_resource.active = 1 AND
				user_privilege.active = 1 
			ORDER BY
				user_module.id,			
				user_resource.id,
				user_privilege.id
			   
		"
		return self.connection.exec_query(query).to_hash
	end
end