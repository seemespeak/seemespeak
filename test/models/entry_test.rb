require 'test_helper'

class EntryTest < ActiveSupport::TestCase

  def setup
    Entry.delete_all
  end

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
    sleep 1

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
    (1..20).each do 
      Entry.new(:tags => "funny tags").index
    end
    sleep 1

    entries = Entry.search(:random => 100, :reviewed => false)
    entries2 = Entry.search(:random => 50, :reviewed => false)

    assert entries.first.id != entries2.first.id
  end

  test "count returns a number of videos" do
    e = Entry.new(:tags => "funny tags")
    e.index
    sleep 1

    count = Entry.count

    assert count
    assert_equal Fixnum, count.class
    assert_equal 1, count
  end

  test "a new entry will be ranked with 0 by default" do
    entry = Entry.new(:transcription => "my transcription",
                      :tags => "foo bar",
                      :flags => "vulgar",
                      :reviewed => false,
                      :language => "abc")

    entry.index

    assert (entry.ranking == 0 )
  end

  test "higher ranked entry (reviewed) occurs at first when searching" do
    entry_ranked_high = Entry.new(:transcription => "my test transcription", 
                                  :tags => "foo bar",
                                  :reviewed => true,
                                  :language => "abc", 
                                  :ranking => 3)

    entry_ranked_low = Entry.new(:transcription => "my test transcription", 
                                 :tags => "foo bar",
                                 :reviewed => true,
                                 :language => "abc", 
                                 :ranking => 2)

    entry_ranked_low.index
    entry_ranked_high.index

    entries = Entry.search(:phrase => "my test transcription")
    rankings = entries.map{ |e| e.ranking }

    assert (rankings == rankings.sort.reverse)
  end
end
