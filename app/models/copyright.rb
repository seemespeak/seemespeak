class Copyright
  include Virtus.model
  include ActiveModel::Validations

  attribute :author
  attribute :link
  attribute :license_accepted, Boolean

  validates :author, :presence => true
  validates_acceptance_of :license_accepted
end
