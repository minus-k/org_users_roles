class ChangeRoleUserTableName < ActiveRecord::Migration
  def change
    rename_table :role_user, :roles_users
  end
end
