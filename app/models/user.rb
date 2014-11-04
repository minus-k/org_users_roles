class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_many :organizations, through: :roles

  def get_access(org_id)
    self.roles.where(organization_id: org_id).first
  end

  def get_orgs
    ids = self.roles.where('type != ?', 'Denied').pluck(:organization_id)
  end
end
