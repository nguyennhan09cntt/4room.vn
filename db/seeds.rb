User.create!([
  {user_name: "admin", password: "7c4a8d09ca3762af61e59520943dc26494f8941b", name: "Super Admin", birthday: "1990-05-05", joined_at: nil, salt: nil, last_login: "2017-09-19", level: 1, manager_id: nil, status: 1, job: "DEV", phone: "0123456", fk_user_role: 1, session_id: nil},
  {user_name: "maith", password: "ad28861da91b06fffd53d6273c1b9658c232b6e3", name: "Trương Hiếu Mai", birthday: nil, joined_at: nil, salt: "874ad6262f315cf31c24876353b6181059590f96", last_login: nil, level: 2, manager_id: 1, status: 0, job: "Admin", phone: "", fk_user_role: 1, session_id: nil}
])
UserAcl.create!([
  {fk_user_role: 1, fk_user_privilege: 1},
  {fk_user_role: 1, fk_user_privilege: 2},
  {fk_user_role: 1, fk_user_privilege: 3},
  {fk_user_role: 1, fk_user_privilege: 4},
  {fk_user_role: 1, fk_user_privilege: 7},
  {fk_user_role: 1, fk_user_privilege: 8},
  {fk_user_role: 1, fk_user_privilege: 9},
  {fk_user_role: 1, fk_user_privilege: 5},
  {fk_user_role: 1, fk_user_privilege: 6},
  {fk_user_role: 1, fk_user_privilege: 10},
  {fk_user_role: 1, fk_user_privilege: 11},
  {fk_user_role: 1, fk_user_privilege: 12},
  {fk_user_role: 1, fk_user_privilege: 13}
])
UserComponent.create!([
  {name: "CMS"},
  {name: "Operation"}
])
UserModule.create!([
  {name: "Administration", fk_user_component: 1, priority: 100},
  {name: "User", fk_user_component: 1, priority: 100},
  {name: "Chuc nang", fk_user_component: 1, priority: 80},
  {name: "Posts Manager", fk_user_component: 1, priority: 70}
])
UserPermission.create!([
  {fk_user: 1, fk_user_privilege: 1},
  {fk_user: 1, fk_user_privilege: 2},
  {fk_user: 1, fk_user_privilege: 3},
  {fk_user: 1, fk_user_privilege: 4},
  {fk_user: 1, fk_user_privilege: 7},
  {fk_user: 1, fk_user_privilege: 8},
  {fk_user: 1, fk_user_privilege: 9},
  {fk_user: 1, fk_user_privilege: 5},
  {fk_user: 1, fk_user_privilege: 6},
  {fk_user: 1, fk_user_privilege: 10},
  {fk_user: 1, fk_user_privilege: 11},
  {fk_user: 1, fk_user_privilege: 12},
  {fk_user: 1, fk_user_privilege: 13}
])
UserPrivilege.create!([
  {fk_user_resource: 1, name: "Danh sach", action: "index", active: 1, priority: 100, display: 1},
  {fk_user_resource: 1, name: "Them moi", action: "new", active: 1, priority: 100, display: 1},
  {fk_user_resource: 2, name: "Danh sách", action: "index", active: 1, priority: 100, display: 1},
  {fk_user_resource: 2, name: "Them moi", action: "new", active: 1, priority: 90, display: 1},
  {fk_user_resource: 3, name: "Danh sach", action: "index", active: 1, priority: 100, display: 1},
  {fk_user_resource: 3, name: "Them moi", action: "new", active: 1, priority: 90, display: 1},
  {fk_user_resource: 4, name: "Danh sach", action: "index", active: 1, priority: 100, display: 1},
  {fk_user_resource: 4, name: "Them moi", action: "new", active: 1, priority: 90, display: 1},
  {fk_user_resource: 5, name: "Danh sách", action: "index", active: 1, priority: 100, display: 1},
  {fk_user_resource: 6, name: "Listing", action: "", active: 1, priority: nil, display: 1},
  {fk_user_resource: 6, name: "Add new", action: "new", active: 1, priority: 90, display: nil},
  {fk_user_resource: 7, name: "Danh sach", action: "", active: 1, priority: 100, display: 1},
  {fk_user_resource: 7, name: "Them moi", action: "new", active: 1, priority: 90, display: 1}
])
UserResource.create!([
  {name: "Module", controller: "module", active: 1, display: 1, priority: 100, fk_user_module: 1},
  {name: "Resource", controller: "resource", active: 1, display: 1, priority: 90, fk_user_module: 1},
  {name: "Quản trị người dùng", controller: "user", active: 1, display: 1, priority: 100, fk_user_module: 2},
  {name: "Privilege", controller: "privilege", active: 1, display: 1, priority: 80, fk_user_module: 1},
  {name: "Role", controller: "role", active: 1, display: 1, priority: 70, fk_user_module: 1},
  {name: "Pending", controller: "pending", active: 1, display: 1, priority: nil, fk_user_module: 4},
  {name: "Site manager", controller: "site", active: 1, display: 1, priority: nil, fk_user_module: 4},
  {name: "Peding", controller: "", active: 1, display: 100, priority: nil, fk_user_module: 4}
])
UserRole.create!([
  {name: "Super Admin"},
  {name: "Admin"},
  {name: "User"},
  {name: "Sale"},
  {name: "Marketing"}
])
