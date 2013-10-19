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

#  test "search" do
#    Entry.new(:transcription => "my transcription",
#              :tags => "foo bar",
#              :flags => "vulgar",
#              :reviewed => true,
#              :language => "abc").index
#
#    entries = Entry.search
#    assert_equal Entry, entries.first.class
#  end

  test "an empty entry is not valid" do
    e = Entry.new()
    assert_equal false, e.valid?
  end

  test "an entry with all fields set is valid" do
    e = Entry.new(:transcription => "my transcription",
                  :tags => "foo bar",
                  :flags => "vulgar",
                  :reviewed => false,
                  :language => "DGS")

    assert_equal true, e.valid?
  end

  test "an entry with unknown flags is invalid" do
    e = Entry.new(:transcription => "my transcription",
                  :tags => "foo bar",
                  :flags => "funny",
                  :reviewed => false,
                  :language => "DGS")

    assert_equal false, e.valid?
  end

  test "an entry with unknown language is invalid" do
    e = Entry.new(:transcription => "my transcription",
                  :tags => "foo bar",
                  :flags => "vulgar",
                  :reviewed => false,
                  :language => "abc")

    assert_equal false, e.valid?
  end

  test "search :reviewed => false returns both reviewed and unreviewed" do
    e = Entry.new(:transcription => "my transcription",
                  :tags => "foo bar",
                  :reviewed => false,
                  :language => "abc")
    e.index

    entries = Entry.search(:reviewed => false)
    assert entries.any? { |e| e.reviewed == false }
  end

  test "standard search returns no unreviewed videos" do
    e = Entry.new(:transcription => "my transcription",
                  :tags => "foo bar",
                  :reviewed => false,
                  :language => "abc")
    e.index

    entries = Entry.search
    assert (entries.all? { |e| e.reviewed? })
  end

  test "standard search finds no flagged content" do
    entry = Entry.new(:transcription => "my transcription",
                      :tags => "foo bar",
                      :flags => "vulgar",
                      :reviewed => false,
                      :language => "abc")
    entry.index

    entries = Entry.search
    assert (entries.none? { |e| e.id == entry.id })
  end

  test "different random seeds generate different result lists" do
    entries = Entry.search(:random => 100, :reviewed => false)
    entries2 = Entry.search(:random => 200, :reviewed => false)

    assert entries.first.id != entries2.first.id
  end

  test "count returns a number of videos" do
    count = Entry.count

    assert count
    assert_equal Fixnum, count.class
  end
end
