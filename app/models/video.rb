class Video
  include Virtus.model

  attribute :length, Fixnum
  attribute :converted, Boolean, :default => false
end
