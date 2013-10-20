class Copyright
  include Virtus.model
  include ActiveModel::Validations

  attribute :author
  attribute :link

  validates :author, :presence => true
end
