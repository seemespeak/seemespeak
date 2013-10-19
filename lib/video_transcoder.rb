require 'shellwords'

class VideoTranscoder

  def transcode(source, target, max_size)
    return false unless File.exist?(source)
    format = get_format(source)
    size = limit_size(format, max_size)
    execute_transcode(source, target, size)
  end

  def create_picture(source, target, size)
    return false unless File.exist?(source)

    Tempfile.open(['image', '.png']) do |f|
      `avconv -y -i #{source} -t 1 -vframes 1 #{Shellwords.shellescape(f.path)}`
      if ![0,11,256].include?($?.exitstatus)
        return false
      end

      `convert #{Shellwords.shellescape(f.path)} -resize #{size.width}x#{size.height}^ -gravity center -extent #{size.width}x#{size.height} #{Shellwords.shellescape(target)}`
    end

    true
  end

  def get_format(movie)
    output = `avconv -i #{Shellwords.shellescape(movie)} 2>&1`
    parse_avconv_info(output)
  end

  def parse_avconv_info(string)
    result = {}
    return result if string.blank?
    result[:version] = string.match(/avconv version (\d*.\d*)/)[1]
    stream_data = string.match(/Stream #\d.\d.* Video: (.*)/)[1]
    format = stream_data.split(",").map(&:strip)
    result[:codec] = format.shift

    format.each do |item|
      if item.match(/(?<width>\d*)x(?<height>\d*)/)
        result[:width] = $~[:width].to_i
        result[:height]= $~[:height].to_i
      end
    end

    result
  end

  def limit_size(format, max_size)
    scale_required = [max_size.width.to_f / format[:width], max_size.height.to_f / format[:height]].min
    if (scale_required < 1)
      return OpenStruct.new(width: (format[:width] * scale_required).round, height: (format[:height] * scale_required).round)
    end

    return OpenStruct.new(width: format[:width], height: format[:height])
  end

  def execute_transcode(source, target, size)
    `avconv -y -i #{Shellwords.shellescape(source)} -an -s #{size.width}x#{size.height} #{Shellwords.shellescape(target)}`
    [0,11,256].include?($?.exitstatus)
  end

end
