class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :organization

  # Scopes for the Role subclasses.
  scope :admin, -> {where(type: 'Admin')}
  scope :denied, -> {where(type: 'Denied')}

  # Allows for dynamic checks on Role types (is_admin?, is_denied?, etc)
  def method_missing(method_id, *args)
    if match = match_role?(method_id)
      self.type.downcase == match.captures.first
    else
      super
    end
  end

  private
  def match_role?(method_id)
    /^is_?([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end
end
