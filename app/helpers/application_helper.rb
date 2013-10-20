module ApplicationHelper

  def link_to_language(lang)
    link_to(explain_language(lang), t("languages.#{lang.downcase}.link"), )
  end

  def explain_language(lang)
    content_tag("abbr", lang, {text:t("languages.#{lang.downcase}.name")})
  end

end
