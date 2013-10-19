require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  test "indexing" do
    e = Entry.new(:transcription => "test")
    e.index
    assert e.id
    assert e.version
  end

  test "get" do
    e = Entry.new(:transcription => "for get")
    e.index
    retrieved = Entry.get(e.id)
    assert_equal Entry, retrieved.class
  end
end
