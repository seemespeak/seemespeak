class Entry
  ALLOWED_FLAGS = ["insult", "vulgar", "casual"]
  ALLOWED_LANGUAGES = ["DGS", "ASL", "BSL"]

  include Virtus.model
  include Concerns::Indexable
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attribute :transcription, String
  attribute :tags,          Array, :coercer => lambda { |input| input.split }, :default => []
  attribute :flags,         Array, :coercer => lambda { |input| input.split }, :default => []
  attribute :reviewed,      Boolean, :default => false
  attribute :language,      String
  attribute :dialect,       String
  attribute :copyright,     Copyright
  attribute :video,         Video

  validates :transcription,
            :tags,
            :language,
            :presence => true
            #:video

  validates :flags, with: :validate_flags
  validates :language, inclusion: ALLOWED_LANGUAGES

  def validate_flags
    unknown_flags = flags - ALLOWED_FLAGS
    unless unknown_flags.empty?
      errors.add(:flags, "Unknown flags: #{flags.join(',')}")
    end
  end
end
