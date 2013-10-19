class Entry
  include Virtus.model

  attribute :transcription, String
  attribute :tags,          Array[String]
  attribute :flags,         Array[String]
  attribute :reviewed,      Boolean
  attribute :language,      String
  attribute :dialect,       String
  attribute :video,         Video
end
