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
    attribute :random, Fixnum
    attribute :ranking, Integer, :default => 0


    def to_hash
      if phrase
        query = { :match => { :transcription => phrase } }
      else
        query = { :match_all => {} }
      end

      bool = Hash.new { |h,k| h[k] = [] }

      if reviewed
        bool[:must] << { :term => { :reviewed => true } }
      else
        bool[:must] << { :term => { :reviewed => false } }
      end

      if ignored_flags
        bool[:must_not] << { :terms => { :flags => ignored_flags } }
      end

      if tags && !tags.empty?
        bool[:must] << { :terms => { :tags => tags } }
      end

      sorting = {}

      if ranking
        sorting = [:ranking => { :order => "desc" }]
      end

      if random
        random_query = {
          :function_score => {
            :query => query,
            :random_score => {
              :seed => random
            }
          }
        }
        { :query => random_query, :filter => { :bool => bool } }
      else
        { :query => query, :filter => { :bool => bool }, :sort => sorting }
      end
    end
  end

  include Virtus.model
  include Concerns::Indexable
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def initialize(hash = {})
    unless hash[:flags] || hash["flags"]
      hash[:flags] = []
      ALLOWED_FLAGS.each do |flag|
        hash[:flags] << flag if hash[flag] && hash[flag] != "0"
      end
    end
    super(hash)
  end

  attribute :transcription, String
  attribute :tags,          Array[String], :coercer => lambda { |input| String === input ? input.split : input }
  attribute :flags,         Array[String], :coercer => lambda { |input| String === input ? input.split : input }
  attribute :reviewed,      Boolean, :default => false
  attribute :language,      String
  attribute :dialect,       String
  attribute :copyright,     Copyright
  attribute :video,         Video
  attribute :ranking,       Integer, :default => 0


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

  def posterframe
    "/videofiles/entry_#{id}/picture.jpg"
  end

  def video_urls
    { 
      "video/webm" => "/videofiles/entry_#{id}/movie.webm",
      "video/mp4"  => "/videofiles/entry_#{id}/movie.mp4"
    }
  end

  ALLOWED_FLAGS.each do |flag|
    define_method flag do
      flags.include? flag
    end
  end
end
