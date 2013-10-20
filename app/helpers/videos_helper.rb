module VideosHelper

  def link_to_videos_with_tag(tag)
  	link_to videos_path(:tag => tag) do
  	  content_tag(:span, tag, :class => "label")
    end
  end

  def length_collection
  	[3, 5, 10].map do |length|
  		["#{length} #{t :seconds}", length]
  	end
  end
end
