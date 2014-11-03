class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :organization_id
      t.integer :user_id
      t.string :type

      t.timestamps
    end
  end
end
