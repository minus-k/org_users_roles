class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_many :organizations, through: :roles

  def get_role(org_id)
    self.roles.where(organization_id: org_id).first
  end
end
