class VideoTranscoder

  def transcode(source, target, max_size)
    format = get_format(source)
    size = calculate_size(format, max_size)
    execute_transcode(source, target, size)
  end

  def create_picture(source, target, max_size)
    format = get_format(source)
    size = calculate_size(format, max_size, true)
    `avconv -y -i #{source} -t 1 -s #{size.width}x#{size.height} -f image2 -vframes 1 #{target}`
    [0,11,256].include?($?.exitstatus)
  end

  def get_format(movie)
    output = `avconv -i #{movie} 2>&1`
    parse_avconv_info(output)
  end

  def parse_avconv_info(string)
    result = {}
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

  def calculate_size(format, max_size, enlarge_if_needed = false)
    scale_required = [max_size.width.to_f / format[:width], max_size.height.to_f / format[:height]].min
    if (enlarge_if_needed || scale_required < 1)
      return OpenStruct.new(width: (format[:width] * scale_required).round, height: (format[:height] * scale_required).round)
    end

    return OpenStruct.new(width: format[:width], height: format[:height])
  end

  def execute_transcode(source, target, size)
    `avconv -y -i #{source} -an -s #{size.width}x#{size.height} #{target}`
    [0,11,256].include?($?.exitstatus)
  end

end
