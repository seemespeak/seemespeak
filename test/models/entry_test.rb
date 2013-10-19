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

  test "coercion" do
    e = Entry.new(:tags => "funny tags")
    assert_equal e.tags, ["funny", "tags"]
  end

  test "search" do
    entries = Entry.search
    assert_equal entries.first.class, Entry
  end
end
