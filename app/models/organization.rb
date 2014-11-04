class Organization < ActiveRecord::Base
  #before_create :check_node_level

  has_many :children, class_name: Organization, foreign_key: :parent_id
  belongs_to :parent, class_name: Organization

  has_many :roles
  has_many :users, through: :roles
              
  # If node is a grandchild, keep as a leaf
  def check_node_level
  end

  # Check nodes and return Organizations a user has access to.
  def set_permissions(uid)
    level = self
    user_role = level.roles.where(user_id: uid)
    while user_role.empty? && level.has_parent?(level)
      level = level.parent
      user_role = level.roles.where(user_id: uid)
    end
    user_role.first
  end

  # Check self and parents for admins.
  def admins
    self.roles.where(type: 'Admin')
  end

  # Check self and parents for denied.
   def denied
     self.roles.where(type: 'Denied')
   end

   def has_parent?(level)
     !level.parent.nil?
   end
end
