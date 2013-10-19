require 'test_helper'
require 'video_transcoder'

class VideoTranscoderTest < ActionView::TestCase

  def setup
    @transcoder = VideoTranscoder.new
  end

  def test_get_format
    format = @transcoder.get_format("test/data/Festplatte.mp4")
    assert_equal(320, format[:width])
    assert_equal(240, format[:height])
  end

  def test_parse_avconv_info
    avconv_string = <<-output
avconv version 9.9, Copyright (c) 2000-2013 the Libav developers
  built on Oct 19 2013 11:25:11 with Apple LLVM version 5.0 (clang-500.2.75) (based on LLVM 3.3svn)
Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'test/data/Festplatte.mp4':
  Metadata:
    major_brand     : isom
    minor_version   : 512
    compatible_brands: isomiso2avc1mp41
    encoder         : Lavf54.63.104
  Duration: 00:00:02.88, start: 0.000000, bitrate: 196 kb/s
    Stream #0.0(und): Video: h264 (High), yuv420p, 320x240, 192 kb/s, 25 fps, 25 tbr, 12800 tbn, 50 tbc
At least one output file must be specified
output
    assert_equal({:version=>"9.9", :codec=>"h264 (High)", :width=>320, :height=>240},
                 @transcoder.parse_avconv_info(avconv_string))
  end

  def test_parse_avconv_info_for_older_version
    avconv_string = <<-output
avconv version 0.8.6-6:0.8.6-1, Copyright (c) 2000-2013 the Libav developers
  built on Mar 24 2013 18:40:26 with gcc 4.7.2
[matroska,webm @ 0x2050b20] Estimating duration from bitrate, this may be inaccurate
Input #0, matroska,webm, from 'Ziege.webm':
  Duration: 00:00:03.03, start: 0.000000, bitrate: N/A
    Stream #0.0: Video: vp8, yuv420p, 640x360, PAR 1:1 DAR 16:9, 30 fps, 30 tbr, 1k tbn, 1k tbc (default)
At least one output file must be specified
output
    assert_equal({:version=>"0.8", :codec=>"vp8", :width=>640, :height=>360},
                 @transcoder.parse_avconv_info(avconv_string))
  end

  def test_limit_size_for_smaller_values_with_resize
    assert_equal(OpenStruct.new(width: 1280, height: 640),
                 @transcoder.limit_size({width: 640, height: 320}, OpenStruct.new(width: 1280, height: 720), true))
  end

  def test_limit_size_for_smaller_values
    assert_equal(OpenStruct.new(width: 640, height: 320),
                 @transcoder.limit_size({width: 640, height: 320}, OpenStruct.new(width: 1280, height: 720)))
  end

  def test_limit_size_for_large_height
    assert_equal(OpenStruct.new(width: 133, height: 320),
                 @transcoder.limit_size({width: 200, height: 480}, OpenStruct.new(width: 640, height: 320)))
  end

  def test_limit_size_for_large_width
    assert_equal(OpenStruct.new(width: 640, height: 160),
                 @transcoder.limit_size({width: 1280, height: 320}, OpenStruct.new(width: 640, height: 320)))
  end

  def test_limit_size_for_really_big_images
    assert_equal(OpenStruct.new(width: 569, height: 320),
                 @transcoder.limit_size({width: 1280, height: 720}, OpenStruct.new(width: 640, height: 320)))
  end
end
