class Organization < ActiveRecord::Base
  # before_create :check_node_level

  has_many :children, class_name: Organization, foreign_key: :parent_id
  belongs_to :parent, class_name: Organization

  has_many :roles
  has_many :users, through: :roles
              
  # Not sure if needed but why not
  def check_node_level
  # If root node exists, save as a child of root.
  # If self is a grandchild of root.  Do not save, keep a leaf.
  end

  # Check self and parents for admins.
  def admins
    self.roles.where(type: 'Admin')
  end

  # Check self and parents for denied.
   def denied
     self.roles.where(type: 'Denied')
   end

  # Add user as an admin
  def add_admin(user)
    self.admins << user
  end

  # Add user as a denied user
  def deny_user(user)
    self.denied << user
  end
end
