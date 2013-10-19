class Video
  include Virtus.model

  attribute :filename, String
  attribute :length, Fixnum
end
