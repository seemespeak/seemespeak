module VideosHelper

  def link_to_videos_with_tag(tag)
    link_to videos_path(:tag => tag) do
      content_tag(:span, tag, :class => "label")
    end
  end

  def length_collection
    [
      [ t(".a_word"), 3 ],
      [ t(".a_long_word"), 5 ],
      [ t(".a_sentence"), 10]
    ]
  end

  def search_result_header
    return "#{params[:transcription]} (word)" if params[:transcription].present?
    return "#{params[:tag]} (tag)"             if params[:tag].present?
  end

  def session_contains_up_vote_for(entry)
    session['upvotes'].present? && session['upvotes'][entry.id.to_s]
  end

  def session_contains_down_vote_for(entry)
    session['downvotes'].present? && session['downvotes'][entry.id.to_s]
  end

  def countdown_image(step_number="X") # Default is a magic value used from Counter.js.coffee :/
    "countdown-#{step_number}.png"
  end

  def preload_image_tag(image)
    content_tag :div, '', style: "background-image: url('#{image_path(image)}');"
  end
end
