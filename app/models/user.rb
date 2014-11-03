class User < ActiveRecord::Base
  has_and_belongs_to_many :roles # <-- Does User care if it has Admin/Denied Roles?
  has_many :organizations, through: :roles

  # Retrieve organizations that the user has admin access to.
  #scope get_organizations
  #  self.admins.organizations #??
  #end
end