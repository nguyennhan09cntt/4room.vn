module RoleHelper
  include UtilsHelper
  def build_privilege(role_id)
    privilege_data = UserAcl.get_all(role_id)
    self.build_array_by_key(privilege_data, 'fk_user_privilege')
  end
end
