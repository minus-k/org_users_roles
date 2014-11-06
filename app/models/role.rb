class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :organization

  # Scopes for the Role subclasses.
  scope :admin, -> {where(type: 'Admin')}
  scope :denied, -> {where(type: 'Denied')}

  def self.types
    %w(Admin Denied)
  end

  # Allows for dynamic checks on Role types (is_admin?, is_denied?, etc)
  def method_missing(method_id, *args)
    if match = matches_dynamic_role_check?(method_id)
      self.type.downcase == match.captures.first
    else
      super
    end
  end

  private
  def matches_dynamic_role_check?(method_id)
    /^is_?([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end
end
