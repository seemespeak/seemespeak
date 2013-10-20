class Copyright
  include Virtus.model
  include ActiveModel::Validations

  attribute :author
  attribute :link
  attribute :license_accepted, Boolean

  validates :author, :presence => true
  validates :license_accepted, :presence => true
end
