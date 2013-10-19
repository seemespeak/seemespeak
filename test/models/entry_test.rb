require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  test "indexing" do
    e = Entry.new(:transcription => "test")
    e.index
    assert true
  end
end
