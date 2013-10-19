class Entry
  ALLOWED_FLAGS = ["insult", "vulgar", "casual"]
  ALLOWED_LANGUAGES = ["DGS", "ASL", "BSL"]

  class Query
    include Virtus.model

    attribute :language
    attribute :ignored_flags, Array[String], :default => ALLOWED_FLAGS  # the ignored flags
    attribute :tags, Array[String] # interesting tags
    attribute :phrase, String
    attribute :reviewed, Boolean, :default => true

    def to_hash
      if phrase
        query = { :match => { :transcription => phrase } }
      else
        query = { :match_all => {} }
      end

      bool = Hash.new { |h,k| h[k] = [] }

      if reviewed
        bool[:must] << { :term => { :reviewed => true } }
      end

      if ignored_flags
        bool[:must_not] << { :terms => { :flags => ignored_flags } }
      end

      if tags && !tags.empty?
        bool[:must] << { :terms => { :tags => tags } }
      end

      { :query => query, :filter => { :bool => bool } }
    end
  end

  include Virtus.model
  include Concerns::Indexable
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :transcription, String
  attribute :tags,          Array[String], :coercer => lambda { |input| String === input ? input.split : input }
  attribute :flags,         Array[String], :coercer => lambda { |input| String === input ? input.split : input }
  attribute :reviewed,      Boolean, :default => false
  attribute :language,      String
  attribute :dialect,       String
  attribute :copyright,     Copyright
  attribute :video,         Video

  validates :transcription,
            :tags,
            :language,
            :presence => true

  validates :flags, with: :validate_flags
  validates :language, inclusion: ALLOWED_LANGUAGES

  def validate_flags
    unknown_flags = flags - ALLOWED_FLAGS
    unless unknown_flags.empty?
      errors.add(:flags, "Unknown flags: #{flags.join(',')}")
    end
  end
end
