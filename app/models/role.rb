class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :organization

  # Scopes for the Role subclasses.
  scope :admin, -> {where(type: 'Admin')}
  scope :denied, -> {where(type: 'Denied')}

  def self.types
    %w(Admin Denied)
  end
end

