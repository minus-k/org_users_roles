class Organization < ActiveRecord::Base
  has_many :children, class_name: Organization, foreign_key: :parent_id
  belongs_to :parent, class_name: Organization

  has_many :roles
  has_many :users, through: :roles

  # Check nodes and return Organizations a user has access to.
  def set_permissions(uid)
    level = self
    user_role = level.roles.where(user_id: uid)
    while user_role.empty? && level.has_parent?(level)
      level = level.parent
      user_role = level.roles.where(user_id: uid)
    end
    user_role
  end

  # Return nodes that a given user has access to.
  def get_allowed_organizations(uid)
    orgs = []
    default_role = self.roles.where(user_id: uid)
    
    # If there is no user role, set it
    if default_role.empty?
      default_role = set_permissions(uid)
    end 

    default_role = default_role.first

    # If user is denied on the node return
    if default_role.is_denied?
      return 'Denied User'
    else
      orgs << self
    end
    
    # Add nodes user has permission for
    self.children.each do |child|
      if child.children.exists?
        child.children.each do |grandchild|
          set_orgs(orgs, grandchild, uid)
        end
      end
      set_orgs(orgs, child, uid)
    end
    orgs
  end

  def set_orgs(orgs, org, uid) 
    role = org.roles.where(user_id: uid).first
    if role.nil? || !role.is_denied?
      orgs << org 
    end
  end

  def has_parent?(level)
   !level.parent.nil?
  end
end
