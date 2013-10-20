module ApplicationHelper

  def link_to_language(lang)
    link_to(content_tag("abbr", lang, {text:t("languages.#{lang.downcase}.name")}), t("languages.#{lang.downcase}.link"), )
  end

end
